//
//  FavouritesViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavouritesDelegate {

    var products:[ProductModel] = []
    
    @IBOutlet weak var favouritesTableView: UITableView!
    
    var delegate:GroceryDelegate?
    
    var favouritesHandler = FavouritesHandler()
    
    var refreshControl = UIRefreshControl()
    
    var loading: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouritesTableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
        
        favouritesTableView.dataSource = self
        favouritesTableView.delegate = self
        
        favouritesHandler.delegate = self
        favouritesHandler.request()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        favouritesTableView.addSubview(refreshControl)
    }

    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        favouritesHandler.request()
    }
    
    func contentLoaded(products: [ProductModel]) {
        loading = false
        refreshControl.endRefreshing()
        self.products = products
        favouritesTableView.reloadData()
    }
    
    func errorHandler(_ message: String) {
        loading = false
        showError(message)
        favouritesTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 3 : products.count
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favouritesHandler.update(product_id: products[indexPath.row].id, favourite: false)
            products.remove(at: indexPath.row)
            favouritesTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.GroceryCell.CellIdentifier , for: indexPath) as! GroceryTableViewCell
        
        if loading == false {
            cell.delegate = self.delegate
            cell.product = products[indexPath.row]
            cell.showAddButton = false
            cell.showStoreName = false
            cell.configureUI()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        } else {
            cell.startLoading()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        vc.product_id = products[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Favourites Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}
