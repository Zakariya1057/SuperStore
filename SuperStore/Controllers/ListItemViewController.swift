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
    
    var listItem: ListItemModel?
    
    var listItemHistory: ListItemHistory {
        return realm.objects(ListItemHistory.self).filter("product_id = \(listItem!.product_id) AND list_id = \(listItem!.list_id)").first!
    }
    
    var listHandler = ListItemsHandler()
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productTotalLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet var promotionButton: UIButton!
    
    let realm = try! Realm()
    
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
        listItem!.quantity = quantity
        updateTotalPrice()
    }
    
    @IBAction func promotionPressed(_ sender: UIButton) {
        
        if listItem?.promotion == nil {
            return
        }
        
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "promotionViewController"))! as! PromotionViewController
        destinationVC.promotion_id = listItem!.promotion!.id
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func configureUI(){
        
        if listItem?.promotion != nil {
            promotionButton.setTitle(listItem!.promotion?.name, for: .normal)
        } else {
            promotionButton.removeFromSuperview()
        }
        quantityLabel.text = String(listItem!.quantity)
        productNameLabel.text = String(listItem!.name) + ( listItem!.weight != "" ? " (\(listItem!.weight!))" : "")
        stepper.value = Double(listItem!.quantity)
        productImageView.downloaded(from: listItem!.largeImage)
        updateTotalPrice()
    }
    
    func updateTotalPrice(){
        productTotalLabel.text = "£" + String(format: "%.2f", listManager.calculateProductPrice(listItem!))
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
        if listItem!.quantity == 0 {
            confirmDelete()
        } else {
            
            try? realm.write {
                listItemHistory.quantity = listItem!.quantity
            }
            
            let data:[String: String] = [
                "product_id": String(listItem!.product_id),
                "quantity": String(listItem!.quantity),
                "ticked_off": String(listItem!.ticked_off)
            ]
            
            listHandler.update(listId: listItem!.list_id, listData: data)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func deleteItem(){
        try? realm.write {
            realm.delete(listItemHistory)
        }
        
        listHandler.delete(list_id: listItem!.list_id, list_data: ["product_id": String(listItem!.product_id)])
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        deleteItem()
    }
    
}
