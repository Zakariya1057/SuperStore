//
//  SearchResultsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SearchResultsDelegate, QuanityChangedDelegate, ListSelectedDelegate, GroceryDelegate {

    @IBOutlet weak var resultsTableView: UITableView!
    
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var filterView: UIView!
    
    var products:[ProductModel] = []
    
    var delegate:GroceryDelegate?
    
    var searchHandler: SearchHandler = SearchHandler()
    
    var type: String?
    var searchName: String?
    
    @IBOutlet weak var totalProductsLabel: UILabel!
    
    var listHandler = ListItemsHandler()
    
    var add_to_list_product_index: Int?
    
    var selected_list_id: Int?
    
    var loading: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
        resultsTableView.dataSource = self
        resultsTableView.delegate = self

        let sortGesture = UITapGestureRecognizer(target: self, action: #selector(sortResults))
        sortView.addGestureRecognizer(sortGesture)
        
        let filterGesture = UITapGestureRecognizer(target: self, action: #selector(filterResults))
        filterView.addGestureRecognizer(filterGesture)

        self.title = searchName!.capitalized
        
        searchHandler.resultsDelegate = self
        searchHandler.requestResults(searchData: ["type": type!, "detail": searchName!])
        
        if(delegate == nil){
            self.navigationItem.rightBarButtonItem = nil
            self.delegate = self
        }
    }
        
    func contentLoaded(stores: [StoreModel], products: [ProductModel]) {
        self.products = products
        loading = false
        totalProductsLabel.text = "\(products.count) Products"
        self.resultsTableView.reloadData()
    }
    
    func errorHandler(_ message: String) {
        loading = false
        self.resultsTableView.reloadData()
        showError(message)
    }
    
    func updateProductQuantity(index: Int, quantity: Int) {
        print(products[index].name)
        print(quantity)
        products[index].quantity = quantity
    }
    
    @objc func filterResults(){
        self.performSegue(withIdentifier: "resultsOption", sender: self)
    }
    
    @objc func sortResults(){
        self.performSegue(withIdentifier: "resultsOption", sender: self)
    }
        
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count == 0 && loading == true ? 3 : products.count
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

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//         return 130.0
//    }
    
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
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Search Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
