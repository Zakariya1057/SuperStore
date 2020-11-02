//
//  Choose your custom row height     } ListViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 30/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import RealmSwift

class ListItemViewController: UIViewController {
    
    var product: ListItemModel?
    
    var listItemHistory: ListItemHistory {
        return realm.objects(ListItemHistory.self).filter("product_id = \(product!.product_id) AND list_id = \(product!.list_id)").first!
    }
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productTotalLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet var promotionButton: UIButton!
    
    let realm = try! Realm()
//    var delegate: PriceChangeDelegate?
    
    var selected_row: Int = 0
    var selected_section: Int = 0
    
    var listManager: ListManager = ListManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    @IBAction func quantityChanged(_ sender: UIStepper) {
        let quantity = Int(sender.value)
        stepper.value = Double(quantity)
        quantityLabel.text = String(quantity)
        product!.quantity = quantity
        updateTotalPrice()
    }
    
    @IBAction func promotionPressed(_ sender: UIButton) {
        
        if product?.promotion == nil {
            return
        }
        
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "promotionViewController"))! as! PromotionViewController
        destinationVC.promotion_id = product!.promotion!.id
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func configureUI(){
        
        if product?.promotion != nil {
            promotionButton.setTitle(product!.promotion?.name, for: .normal)
        } else {
            promotionButton.removeFromSuperview()
        }
        quantityLabel.text = String(product!.quantity)
        productNameLabel.text = String(product!.name) + ( product!.weight != "" ? " (\(product!.weight!))" : "")
        stepper.value = Double(product!.quantity)
        productImageView.downloaded(from: product!.largeImage)
        updateTotalPrice()
    }
    
    func updateTotalPrice(){
        productTotalLabel.text = "£" + String(format: "%.2f", listManager.calculateProductPrice(product!))
    }
    
    func confirmDelete(){
        let alert = UIAlertController(title: "Removing Product?", message: "Are you sure you want to remove product?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            self.deleteItem()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if product!.quantity == 0 {
            confirmDelete()
        } else {
            
            try? realm.write {
                listItemHistory.quantity = product!.quantity
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func deleteItem(){
        
        try? realm.write {
            realm.delete(listItemHistory)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        deleteItem()
    }
    
}
