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
    func showGroceryItem(_ product_id: Int)
    func addToList(_ product: ProductModel)
    func removeFromList(_ product: ProductModel)
    func updateQuantity(_ product: ProductModel)
}

protocol QuanityChangedDelegate {
    func updateProductQuantity(index: Int, quantity: Int)
}

//    func productAdded(product: ProductModel,parent_category_id: Int,parent_category_name: String)
//    func productRemoved(product: ProductModel, parent_category_id: Int)
//    func productQuantityChanged(product: ProductModel,parent_category_id: Int)

class GroceryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storeNameLabel: UILabel!
    
    var delegate:GroceryDelegate?
    
    var grandParentCategory: GrandParentCategoryModel?
    
    @IBOutlet weak var stepper_stack_view: UIStackView!
    @IBOutlet weak var stepper_label: UILabel!
    var product: ProductModel?
    
    var showAddButton:Bool = true
    var showStoreName: Bool = true
    var show_quantity:Bool = false
    
    var quantity_delegate: QuanityChangedDelegate?
    
    var index: Int?
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewView: CosmosView!
    @IBOutlet weak var left_info_view: UIView!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    var loadingViews: [UIView] {
        return [productImage,productNameLabel,reviewView,bottomStackView]
    }
    
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
        
        stopLoading()
        productNameLabel.text = current_product.name
        priceLabel.text = "£" + String(format: "%.2f", current_product.price)
        
        productImage.downloaded(from: current_product.image)
        
        if(product!.quantity > 0){
            show_quantity_view()
            
            stepper_label.text = String(product!.quantity)
            quantityStepper.value = Double(product!.quantity)
        } else {
            if(showAddButton){
                stepper_label.text = "1"
                quantityStepper.value = 1
                
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
                delegate?.removeFromList(product!)
                show_add_button_view()
            } else {
                delegate?.updateQuantity(product!)
            }
        }
        
        // Used for remembering product quantity. For Scrolling.
        quantity_delegate?.updateProductQuantity(index: index!, quantity: product!.quantity)
        
    }
    
    
    @IBAction func groceryAddClicked(_ sender: Any) {
        show_quantity_view()
        self.delegate?.addToList(self.product!)
        quantity_delegate?.updateProductQuantity(index: index!, quantity: 1)
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
}
