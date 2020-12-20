//
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
        return realm.objects(ListItemHistory.self).filter("productID = \(listItem!.productID) AND listID = \(listItem!.listID)").first!
    }
    
    var listHandler = ListItemsHandler()
    var listManager = ListManager()
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productTotalLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    var parentCategoryId: Int?
    
    @IBOutlet var promotionButton: UIButton!
    
    let realm = try! Realm()
    
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
        destinationVC.promotionID = listItem!.promotion!.id
        
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
            
            updateItem()
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func updateItem(){
        let data:[String: String] = [
            "product_id": String(listItem!.productID),
            "quantity": String(listItem!.quantity),
            "ticked_off": String(listItem!.tickedOff)
        ]
        
        listHandler.update(listID: listItem!.listID, listData: data)
    }
    
    func deleteItem(){
        listItem!.quantity = 0
        listManager.removeProductFromList(listID: listItem!.listID, parentCategoryId: parentCategoryId!, item: listItemHistory)
        updateItem()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        deleteItem()
    }
    
}
