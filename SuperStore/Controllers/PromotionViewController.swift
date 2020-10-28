//
//  PromotionViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 06/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import RealmSwift

class PromotionViewController: UIViewController, PromotionDelegate, UITableViewDelegate, UITableViewDataSource {

    let realm = try! Realm()
    
    var promotionHandler = PromotionHandler()
    
    var promotion_id: Int?
    var userHandler = UserHandler()
    
    var promotion: PromotionHistory? {
        return realm.objects(PromotionHistory.self).filter("id = %@", promotion_id!).first
    }
    
    var products:[ProductModel] = []
    
    @IBOutlet weak var productsTableView: UITableView!
    
    @IBOutlet weak var promotionNameLabel: UILabel!
    @IBOutlet weak var promotionExpiresLabel: UILabel!
    @IBOutlet weak var promotionExpiryView: UIView!
    @IBOutlet var promotionNameView: UIView!
    
    var delegate:GroceryDelegate?
    
    var loadingViews: [UIView] {
        return [promotionNameView, promotionExpiryView]
    }
    
    var loading: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promotionHandler.delegate = self
        promotionHandler.request(promotion_id: promotion_id!)
        
        productsTableView.delegate = self
        productsTableView.dataSource = self

        productsTableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
        
        if promotion != nil && promotion!.products.count > 0 {
            
            for product in promotion!.products {
                let product = realm.objects(ProductHistory.self).filter("id = %@", product).first
                
                if product != nil {
                    products.append(product!.getProductModel())
                }
            }
            
            loading = false
            productsTableView.reloadData()
        } else {
            startLoading()
        }
        
    }
    
    func contentLoaded(promotion: PromotionModel) {
        addToHistory(promotion)
        
        products = promotion.products
        
        stopLoading()
        loading = false
  
        self.title = promotion.name
        
        productsTableView.reloadData()
        
    }
    
    func errorHandler(_ message: String) {
        stopLoading()
        loading = false
        productsTableView.reloadData()
        showError(message)
    }
    
    func logOutUser(){
        userHandler.userSession.viewController = self
        userHandler.requestLogout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 3 : products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.GroceryCell.CellIdentifier , for: indexPath) as! GroceryTableViewCell
        
        
        
        if loading == false {
            cell.product = products[indexPath.row]
            
            if self.delegate != nil {
                cell.delegate = self.delegate
            } else {
                cell.showAddButton = false
                cell.showStoreName = false
            }

            cell.configureUI()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        } else {
            cell.startLoading()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        destinationVC.product_id = products[indexPath.row].id
        destinationVC.delegate = self.delegate
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func startLoading(){
        for item in loadingViews {
            item.isSkeletonable = true
            item.showAnimatedGradientSkeleton()
        }
    }
    
    func stopLoading(){
        for item in loadingViews {
            item.hideSkeleton()
        }
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Promotion Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}

extension PromotionViewController {
    func addToHistory(_ promotionItem: PromotionModel){

        try! realm.write() {

            if promotion != nil {
                promotion!.products = List<Int>()
                promotionItem.products.forEach({ promotion!.products.append($0.id) })
                promotion!.name = promotionItem.name
                promotion!.price = promotionItem.price ?? 0
                promotion!.quantity = promotionItem.quantity
                promotion!.forQuantity = promotionItem.forQuantity ?? 0
            } else {
                realm.add(promotionItem.getRealmObject())
            }
            
            for product in promotionItem.products {
                let productHistory = realm.objects(ProductHistory.self).filter("id = \(product.id)").first
                
                if productHistory == nil {
                    realm.add(product.getRealmObject())
                }
                
            }

        }
        
    }
    
}
