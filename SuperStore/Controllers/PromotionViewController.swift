//
//  PromotionViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 06/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class PromotionViewController: UIViewController, PromotionDelegate, UITableViewDelegate, UITableViewDataSource {

    var promotionHandler = PromotionHandler()
    
    var promotion_id: Int = 3
    var promotion: PromotionModel?
    
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
        promotionHandler.request(promotion_id: promotion_id)
        // Do any additional setup after loading the view.
        
        productsTableView.delegate = self
        productsTableView.dataSource = self

        productsTableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
        
        startLoading()
    }
    
    func contentLoaded(promotion: PromotionModel) {
        self.promotion = promotion
        
        stopLoading()
        loading = false
  
        self.title = promotion.name
//        promotionNameLabel.text = promotion.name
//
//        if promotion.ends_at == nil {
//            promotionExpiryView.removeFromSuperview()
//        } else {
//            promotionExpiresLabel.text = promotion.ends_at!
//        }
        
        productsTableView.reloadData()
        
    }
    
    func errorHandler(_ message: String) {
        stopLoading()
        loading = false
        productsTableView.reloadData()
        showError(message)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 3 : (self.promotion?.products?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.GroceryCell.CellIdentifier , for: indexPath) as! GroceryTableViewCell
        
        if loading == false {
            cell.product = promotion!.products![indexPath.row]
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
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        destinationVC.product_id = promotion!.products![indexPath.row].id
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
