//
//  SearchResultsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SearchResultsDelegate, QuanityChangedDelegate, ListSelectedDelegate, GroceryDelegate, RefineSelectedDelegate {
    
    @IBOutlet weak var resultsTableView: UITableView!
    
    @IBOutlet var refineView: UIView!
    
    var products:[ProductModel] = []
    
    var delegate:GroceryDelegate?
    
    var searchHandler: SearchHandler = SearchHandler()
    
    var type: String?
    var searchName: String?
    
    @IBOutlet weak var totalProductsLabel: UILabel!
    
    var listHandler = ListItemsHandler()
    
    var add_to_list_product_index: Int?
    
    var selected_list_id: Int?
    
    var selectedSort: RefineSortModel?
    var selectedCategory: RefineModel?
    var selectedBrand: RefineModel?
    var selectedDietary: [RefineModel] = []
    
    var loading: Bool = true
    
    var refreshControl = UIRefreshControl()
    
    var filters: [RefineOptionModel] = []
    
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
            data["category"] = selectedCategory!.name
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
        print(products[index].name)
        print(quantity)
        products[index].quantity = quantity
    }
    
    
    func addToList(_ product: ProductModel){
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "listsViewController"))! as! ListsViewController
        destinationVC.delegate = self
        self.present(destinationVC, animated: true)
        self.add_to_list_product_index = product.id
    }
    
    func list_selected(list_id: Int) {
        self.selected_list_id = list_id
        listHandler.create(list_id: list_id, list_data: ["product_id": String(add_to_list_product_index!)])
    }
    
    func update_quantity(_ product: ProductModel) {
        let data:[String: String] = [
            "product_id": String(product.id),
            "quantity": String(product.quantity),
            "ticked_off": "false"
        ]
        
        listHandler.update(list_id:selected_list_id!, list_data: data)
        
    }
    
    @IBAction func donePressed(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    func showGroceryItem(_ product_id: Int) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        destinationVC.product_id = product_id
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
        showGroceryItem(products[indexPath.row].id)
    }

    @objc func refresh(){
        search()
    }

}
