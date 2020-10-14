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
    
    var selected_product_id: Int?
    var selected_row: GroceryTableViewCell?
    
    var selected_list_id: Int?
    
    var selectedSort: RefineSortModel?
    var selectedCategory: RefineModel?
    var selectedBrand: RefineModel?
    var selectedDietary: [RefineModel] = []
    
    var loading: Bool = true
    
    var refreshControl = UIRefreshControl()
    
    var filters: [RefineOptionModel] = []
    
    var noDelegateFound: Bool = false
    
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
        
        if(delegate == nil){
            self.noDelegateFound = true
            self.navigationItem.rightBarButtonItem = nil
            self.delegate = self
        }
    }
        
    func contentLoaded(stores: [StoreModel], products: [ProductModel], filters: [RefineOptionModel]) {
        self.products = products
        self.filters = filters
        loading = false
        totalProductsLabel.text = "\(products.count) Products"
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
    
    func search(){
        
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
        
        
        loading = true
        
        if products.count > 0 {
            resultsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
        resultsTableView.reloadData()
        
        searchHandler.requestResults(searchData: data)
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
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "listsViewController"))! as! ListsViewController
        destinationVC.delegate = self
        present(destinationVC, animated: true)
        
        selected_product_id = product.id
        selected_row = cell
    }
    
    func listSelected(list_id: Int) {
        self.selected_list_id = list_id
        listHandler.create(list_id: list_id, list_data: ["product_id": String(selected_product_id!)])
        
        selected_row!.show_quantity_view()
    }
    
    func update_quantity(_ product: ProductModel) {
        let data:[String: String] = [
            "product_id": String(product.id),
            "quantity": String(product.quantity),
            "ticked_off": "false"
        ]
        
        try! realm.write() {
            var list = realm.objects(ListItemHistory.self).filter("list_id = \(selected_list_id!) AND product_id = \(product.id)").first
            
            if list == nil {
                let listItem = ListItemHistory()
                listItem.name = product.name
                listItem.image = product.image
                listItem.price = product.price
                listItem.discount = product.discount?.getRealmObject()
                listItem.list_id = selected_list_id!
                listItem.quantity = 1
                
                realm.add(listItem)
                
                list = listItem
            }
            
            if product.quantity != 0 {
                list!.quantity = product.quantity
            } else {
                realm.delete(list!)
            }
            
        }
        
        listHandler.update(list_id:selected_list_id!, list_data: data)
        
    }
    
    @IBAction func donePressed(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    func showGroceryItem(_ product_id: Int) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        destinationVC.product_id = product_id
        destinationVC.delegate = noDelegateFound ? nil : self.delegate
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func removeFromList(_ product: ProductModel) {
        
    }
    
    func updateQuantity(_ product: ProductModel) {
        update_quantity(product)
    }
}

//MARK: - TableView
extension SearchResultsViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 5 : products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTableView.dequeueReusableCell(withIdentifier:K.Cells.GroceryCell.CellIdentifier , for: indexPath) as! GroceryTableViewCell
        
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
