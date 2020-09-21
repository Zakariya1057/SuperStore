//
//  SearchResultsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SearchResultsDelegate, GroceryDelegate {

    @IBOutlet weak var resultsTableView: UITableView!
    
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var filterView: UIView!
    
    var products:[ProductModel] = []
    
    var delegate:GroceryDelegate?
    
    var searchHandler: SearchHandler = SearchHandler()
    
    var type: String?
    var searchName: String?
    
    @IBOutlet weak var totalProductsLabel: UILabel!
    
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
    }
        
    func contentLoaded(stores: [StoreModel], products: [ProductModel]) {
        self.products = products
        totalProductsLabel.text = "\(products.count) Products"
        print(products)
        self.resultsTableView.reloadData()
    }
    
    @objc func filterResults(){
        self.performSegue(withIdentifier: "resultsOption", sender: self)
    }
    
    @objc func sortResults(){
        self.performSegue(withIdentifier: "resultsOption", sender: self)
    }
        
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTableView.dequeueReusableCell(withIdentifier:K.Cells.GroceryCell.CellIdentifier , for: indexPath) as! GroceryTableViewCell
        cell.delegate = self.delegate
        cell.product = products[indexPath.row]
        cell.configureUI()
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        show_grocery_item(products[indexPath.row].id)
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//         return 130.0
//    }
    
    func show_grocery_item(_ product_id: Int) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        destinationVC.product_id = product_id
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func add_to_list(_ product: ProductModel) {
        
    }
    
    func remove_from_list(_ product: ProductModel) {
        
    }
    
    func update_quantity(_ product: ProductModel) {
        
    }
}
