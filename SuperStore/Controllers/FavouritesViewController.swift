//
//  FavouritesViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import RealmSwift

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavouritesDelegate {
    
    @IBOutlet weak var favouritesTableView: UITableView!
    
    let realm = try! Realm()
    lazy var favourites: Results<ProductHistory> = { self.realm.objects(ProductHistory.self).filter("favourite = true").sorted(byKeyPath: "updated_at", ascending: false)}()
    

    var delegate:GroceryDelegate?
    
    var favouritesHandler = FavouritesHandler()
    
    var userHandler = UserHandler()
    
    var refreshControl = UIRefreshControl()
    
    var loading: Bool = true
    
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouritesTableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
        
        favouritesTableView.dataSource = self
        favouritesTableView.delegate = self
        
        favouritesHandler.delegate = self
        favouritesHandler.request()
        
        let results = realm.objects(ProductHistory.self)

        // Observe Results Notifications
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
                case .initial:
                    // Results are now populated and can be accessed without blocking the UI
                    self?.favouritesTableView.reloadData()
            case .update(_, _, _, _):
                    self?.favouritesTableView.reloadData()
                    break
                case .error(let error):
                    fatalError("\(error)")
            }
        }
        
        if favourites.count > 0{
            loading = false
            favouritesTableView.reloadData()
        }
        
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

        let products = products.reversed()
        for product in products {
            product.favourite = true
            addToFavourite(product)
        }
        
        favouritesTableView.reloadData()
    }
    
    func errorHandler(_ message: String) {
        loading = false
        showError(message)
        favouritesTableView.reloadData()
    }

    func logOutUser(){
        userHandler.userSession.viewController = self
        userHandler.requestLogout()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 3 : favourites.count
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favouritesHandler.update(product_id: favourites[indexPath.row].getProductModel().id, favourite: false)
            
            try! realm.write() {
                favourites[indexPath.row].favourite = false
            }

            favouritesTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.GroceryCell.CellIdentifier , for: indexPath) as! GroceryTableViewCell
        
        if loading == false {
            cell.delegate = self.delegate
            cell.product = favourites[indexPath.row].getProductModel()
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
        vc.product_id = favourites[indexPath.row].getProductModel().id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Favourites Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func addToFavourite(_ product: ProductModel){
        let productItem = favourites.filter("id = \(product.id)").first
        
        let productHistory = realm.objects(ProductHistory.self).filter("id = \(product.id)").first
        
        try! realm.write() {
            if productItem == nil {
                
                if productHistory == nil {
                    realm.add(product.getRealmObject())
                } else {
                    productHistory!.favourite = true
                }
                
            } else {
                productItem!.updated_at = Date()
                productItem!.name = product.name
                productItem!.image = product.image
                productItem!.avgRating = product.avgRating
                productItem!.totalReviewsCount = product.totalReviewsCount
            }
        }
    }
    
}
