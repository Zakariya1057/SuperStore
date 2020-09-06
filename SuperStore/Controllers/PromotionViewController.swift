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
    
    var delegate:GroceryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promotionHandler.delegate = self
        promotionHandler.request(promotion_id: promotion_id)
        // Do any additional setup after loading the view.
        
        productsTableView.delegate = self
        productsTableView.dataSource = self

        productsTableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
    }
    
    func contentLoaded(promotion: PromotionModel) {
        self.promotion = promotion
        
        promotionNameLabel.text = promotion.name
        
        if promotion.ends_at == nil {
            promotionExpiryView.removeFromSuperview()
        } else {
            promotionExpiresLabel.text = promotion.ends_at!
        }
        
        productsTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.promotion?.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.GroceryCell.CellIdentifier , for: indexPath) as! GroceryTableViewCell
        cell.product = promotion!.products![indexPath.row]
        cell.showAddButton = false
        cell.showStoreName = false
        cell.configureUI()
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if promotion!.products![indexPath.row].name.count > 34 {
             return 130.0
        } else {
             return 110.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        vc.product_id = promotion!.products![indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
