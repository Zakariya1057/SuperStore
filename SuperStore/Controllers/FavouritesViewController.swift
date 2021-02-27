////
////  FavouritesViewController.swift
////  SuperStore
////
////  Created by Zakariya Mohummed on 22/07/2020.
////  Copyright © 2020 Zakariya Mohummed. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//
//class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavouritesDelegate {
//    
//    @IBOutlet weak var favouritesTableView: UITableView!
//    
//    let realm = try! Realm()
//    lazy var favourites: Results<ProductHistory> = { self.realm.objects(ProductHistory.self).filter("favourite = true").sorted(byKeyPath: "updatedAt", ascending: false)}()
//    
//    var delegate:GroceryDelegate?
//    
//    var favouritesHandler = FavouritesHandler()
//    
//    var userHandler = UserHandler()
//    
//    var refreshControl = UIRefreshControl()
//    
//    var loading: Bool = true
//    
//    var notificationToken: NotificationToken?
//    
//    var offline: Bool {
//        return RequestHandler.sharedInstance.offline
//    }
//    
//    var loggedIn: Bool {
//        return userHandler.userSession.isLoggedIn()
//    }
//    
//    var loadingCell: Int = 1
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        favouritesTableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
//        
//        favouritesTableView.register(UINib(nibName: K.Cells.LoginToUseTableCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.LoginToUseTableCell.CellIdentifier)
//        
//        favouritesTableView.dataSource = self
//        favouritesTableView.delegate = self
//        
//        favouritesHandler.delegate = self
//        
//        if(loggedIn){
//            favouritesHandler.request()
//            
//            refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
//            refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
//            favouritesTableView.addSubview(refreshControl)
//        }
//        
//        let results = realm.objects(ProductHistory.self)
//        
//        // Observe Results Notifications
//        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
//            switch changes {
//            case .initial:
//                // Results are now populated and can be accessed without blocking the UI
//                self?.favouritesTableView.reloadData()
//            case .update(_, _, _, _):
//                self?.favouritesTableView.reloadData()
//                break
//            case .error(let error):
//                fatalError("\(error)")
//            }
//        }
//        
//        if favourites.count > 0{
//            loading = false
//            favouritesTableView.reloadData()
//        }
//        
//    }
//    
//    @objc func refresh(_ sender: AnyObject) {
//        if !offline {
//            favouritesHandler.request()
//        } else {
//            refreshControl.endRefreshing()
//        }
//    }
//    
//    func contentLoaded(products: [ProductModel]) {
//        loading = false
//        refreshControl.endRefreshing()
//        
//        favouritesHandler.addToFavourite(products)
//        
//        favouritesTableView.reloadData()
//    }
//    
//    func errorHandler(_ message: String) {
//        loading = false
//        showError(message)
//        favouritesTableView.reloadData()
//    }
//    
//    func logOutUser(){
//        userHandler.userSession.viewController = self
//        userHandler.requestLogout()
//    }
//    
//    deinit {
//        notificationToken?.invalidate()
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return loading ? loadingCell : favourites.count
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//            favouritesHandler.update(productID: favourites[indexPath.row].getProductModel().id, favourite: false)
//            
//            try! realm.write() {
//                favourites[indexPath.row].favourite = false
//            }
//            
//            favouritesTableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return loggedIn
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = loggedIn ?
//            tableView.dequeueReusableCell(withIdentifier:K.Cells.GroceryCell.CellIdentifier , for: indexPath) as! GroceryTableViewCell :
//            tableView.dequeueReusableCell(withIdentifier:K.Cells.LoginToUseTableCell.CellIdentifier , for: indexPath) as! LoginToUseTableViewCell
//
//        cell.selectionStyle = .none
//        
//        if let cell = cell as? GroceryTableViewCell {
//            if loading == false {
//                cell.delegate = self.delegate
//                cell.product = favourites[indexPath.row].getProductModel()
//                cell.hideAll = true
//                cell.product!.quantity = 0
//                cell.configureUI()
//            } else {
//                cell.startLoading()
//            }
//        } else if let cell = cell as? LoginToUseTableViewCell {
//            cell.delegate = self
//            cell.page = "favourites"
//            cell.awakeFromNib()
//        }
//
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if !loggedIn {
//            return
//        }
//        
//        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
//        destinationVC.productID = favourites[indexPath.row].getProductModel().id
//        self.navigationController?.pushViewController(destinationVC, animated: true)
//    }
//    
//    func showError(_ error: String){
//        let alert = UIAlertController(title: "Favourites Error", message: error, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//        self.present(alert, animated: true)
//    }
//
//}
//
//extension FavouritesViewController: LoginPressedDelegate {
//    func loginPressed(){
//        self.tabBarController?.selectedIndex = 4
//    }
//}
