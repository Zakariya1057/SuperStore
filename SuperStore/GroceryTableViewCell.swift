//
//  GroceryTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 24/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import Cosmos

protocol GroceryDelegate {
    func show_grocery_item(_ product_id: Int)
    func add_to_list(_ product: ProductModel)
    func remove_from_list(_ product: ProductModel)
    func update_quantity(_ product: ProductModel)
}

class GroceryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storeNameLabel: UILabel!
    
    var delegate:GroceryDelegate?
    
    @IBOutlet weak var stepper_stack_view: UIStackView!
    @IBOutlet weak var stepper_label: UILabel!
    var product: ProductModel?
    
    var showAddButton:Bool = true
    var showStoreName: Bool = true
    var show_quantity:Bool = false
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewView: CosmosView!
    @IBOutlet weak var left_info_view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureUI(){
        let current_product = product!
        
        productNameLabel.text = current_product.name
        priceLabel.text = "£" + String(format: "%.2f", current_product.price)
        
        productImage.downloaded(from: current_product.image)
        
        if(product!.quantity > 0){
            show_quantity_view()
        } else {
            if(showAddButton){
                show_add_button_view()
            } else {
                show_store_name_view()
            }
        }
        
        let rating = current_product.avg_rating ?? 0
        let num = current_product.total_reviews_count ?? 0
        
        reviewView.rating = rating
        reviewView.text = "(\(num))"
    }
    
    @IBAction func stepper_pressed(_ sender: UIStepper) {
        let quantity = sender.value
        stepper_label.text = String(format: "%.0f", quantity)
        
        product!.quantity = Int(quantity)
        
        if delegate != nil {
            if(quantity == 0){
                delegate?.remove_from_list(product!)
                show_add_button_view()
            } else {
                delegate?.update_quantity(product!)
            }
        }
        
    }
    
    @IBAction func groceryAddClicked(_ sender: Any) {
        show_quantity_view()
        self.delegate?.add_to_list(self.product!)
    }
    
    
    func show_quantity_view(){
        stepper_stack_view.isHidden = false
        left_info_view.isHidden = true
    }
    
    func show_add_button_view(){
        left_info_view.isHidden = false
        stepper_stack_view.isHidden = true
        storeNameLabel.isHidden = true
        addButton.isHidden = false
    }
    
    func show_store_name_view(){
        left_info_view.isHidden = false
        stepper_stack_view.isHidden = true
        storeNameLabel.isHidden = false
        addButton.isHidden = true
    }
}
