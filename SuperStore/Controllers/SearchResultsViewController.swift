//
//  SearchResultsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import RealmSwift

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SearchResultsDelegate, QuanityChangedDelegate, ListSelectedDelegate, GroceryDelegate, RefineSelectedDelegate {
    
    let realm = try! Realm()
    
    @IBOutlet weak var resultsTableView: UITableView!
    
    @IBOutlet var refineView: UIView!
    
    var products:[ProductModel] = []
    
    var delegate:GroceryDelegate?
    
    var searchHandler: SearchHandler = SearchHandler()
    
    var type: String?
    var searchName: String?
    
    @IBOutlet weak var totalProductsLabel: UILabel!
    
    var listHandler = ListItemsHandler()
    
    var selected_product: ProductModel?
    var selected_row: GroceryTableViewCell?
    
    var selectedListId: Int?
    
    var selectedSort: RefineSortModel?
    var selectedCategory: RefineModel?
    var selectedBrand: RefineModel?
    var selectedDietary: [RefineModel] = []
    
    var currentPage: Int = 1
    var loading: Bool = true
    
    var refreshControl = UIRefreshControl()
    
    var filters: [RefineOptionModel] = []
    var paginate: PaginateResultsModel?
    
//    var noDelegateFound: Bool = false
    var listRequired: Bool = true
    
    var listManager: ListManager = ListManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        resultsTableView.addSubview(refreshControl)
        
        let refineGesture = UITapGestureRecognizer(target: self, action: #selector(refinePressed))
        refineView.addGestureRecognizer(refineGesture)

        self.title = searchName!.capitalized
        
        searchHandler.resultsDelegate = self
        search()
        
        self.delegate = self
        
        if(selectedListId != nil){
            self.listRequired = false
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
        
    func contentLoaded(stores: [StoreModel], products: [ProductModel], filters: [RefineOptionModel], paginate: PaginateResultsModel?) {
        self.products.append(contentsOf: products)
        self.filters.append(contentsOf: filters)
        self.paginate = paginate

        loading = false
        totalProductsLabel.text = "\(self.products.count) Products"
        resultsTableView.reloadData()
        refreshControl.endRefreshing()

    }
    
    func errorHandler(_ message: String) {
        loading = false
        self.resultsTableView.reloadData()
        showError(message)
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Search Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}

//MARK: - Refine Results
extension SearchResultsViewController {
    
    func applyOptions(sort: RefineSortModel?, category: RefineModel?,brand: RefineModel?, dietary: [RefineModel]){
        selectedSort = sort
        selectedCategory = category
        selectedDietary = dietary
        selectedBrand = brand
        
        search()
    }
    
    func search(refresh: Bool = true){
        
        var data = ["type": type!, "detail": searchName!]
        
        if selectedSort != nil {
            let sortBy = selectedSort!.sort
            let orderBy: String
            
            if selectedSort!.order == .asc {
                orderBy = "asc"
            } else {
                orderBy = "desc"
            }
            
            data["sort"] = sortBy
            data["order"] = orderBy
        }
        
        if selectedCategory != nil {
            data["child_category"] = selectedCategory!.name
        }
        
        if selectedBrand != nil {
            data["brand"] = selectedBrand!.name
        }
        
        if selectedDietary.count > 0 {
            data["dietary"] = selectedDietary.compactMap({ $0.name }).joined(separator: ",")
        }
        
        
        if refresh {
            
            loading = true
            
            if products.count > 0 {
                resultsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
            
            resultsTableView.reloadData()
        }
        
        searchHandler.requestResults(searchData: data, page: currentPage)
    }
    
    func clearAllOptions() {
        selectedSort = nil
        selectedCategory = nil
        selectedDietary = []
        selectedBrand = nil
        
        loading = true
        resultsTableView.reloadData()
        
        search()
    }
    
    
    @objc func refinePressed(){
        if loading == false {
            self.performSegue(withIdentifier: "resultsOption", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultsOption" {
            let destinationVC = segue.destination as! RefineViewController
            destinationVC.delegate = self
            destinationVC.refineHistory = RefineHistoryModel(sort: selectedSort, category: selectedCategory,dietary: selectedDietary, brand: selectedBrand)
            destinationVC.filters = self.filters
        }
    }
    
}

//MARK: - List
extension SearchResultsViewController {
    
    func updateProductQuantity(index: Int, quantity: Int) {
        products[index].quantity = quantity
    }
    
    
    func addToList(_ product: ProductModel, cell: GroceryTableViewCell?){
        
        selected_product = product
        selected_row = cell
        
        if listRequired {
            let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "listsViewController"))! as! ListsViewController
            destinationVC.delegate = self
            present(destinationVC, animated: true)
        } else {
            let item = listManager.addProductToList(listId: selectedListId!, product: selected_product!)
            selected_row!.product?.quantity = item.quantity
            selected_row!.show_quantity_view()
            selected_row!.configureUI()
        }

    }
    
    func listSelected(list_id: Int) {
        self.selectedListId = list_id
        listHandler.create(list_id: list_id, list_data: ["product_id": String(selected_product!.id)])
        
        let item = listManager.addProductToList(listId: list_id, product: selected_product!)
        selected_row!.product?.quantity = item.quantity
        selected_row!.show_quantity_view()
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    func showGroceryItem(_ product_id: Int) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        destinationVC.product_id = product_id
        
        if !listRequired {
            destinationVC.selectedListId = selectedListId
            destinationVC.itemQuantity = 5 // Set In future, when setting quantity with showing results
        }
        
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func updateQuantity(_ product: ProductModel) {
        let data:[String: String] = [
            "product_id": String(product.id),
            "quantity": String(product.quantity),
            "ticked_off": "false"
        ]
        
        listManager.updateProduct(listId: selectedListId!, product: product)
            
        listHandler.update(listId:selectedListId!, listData: data)
    }
}

//MARK: - TableView
extension SearchResultsViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 5 : products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTableView.dequeueReusableCell(withIdentifier:K.Cells.GroceryCell.CellIdentifier , for: indexPath) as! GroceryTableViewCell
        
        if paginate != nil && paginate!.more_available && indexPath.row + 1 == products.count && currentPage <= paginate!.to{
            // Load More Items At End
            currentPage = currentPage + 1
            search(refresh: false)
        }
        
        if loading == false {
            cell.delegate = self.delegate
            cell.quantity_delegate = self
            cell.product = products[indexPath.row]
            cell.index = indexPath.row
            cell.configureUI()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        } else {
            cell.startLoading()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_row = tableView.cellForRow(at: indexPath) as? GroceryTableViewCell
        showGroceryItem(products[indexPath.row].id)
    }

    @objc func refresh(){
        search()
    }

}
