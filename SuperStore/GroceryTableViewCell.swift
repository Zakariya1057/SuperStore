//
//  GroceryTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 24/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

protocol GroceryDelegate {
    func showGroceryItem()
    func addToList(_ product: ProductModel)
}

class GroceryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storeNameLabel: UILabel!
    
    var delegate:GroceryDelegate?
    
    var product: ProductModel?
    
    var showAddButton:Bool = true
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBAction func groceryAddClicked(_ sender: Any) {
        self.delegate?.addToList(self.product!)
    }
    
    func configureUI(){
        let currentProduct = product!
        
        productNameLabel.text = currentProduct.name
        priceLabel.text = String(format: "%.2f", currentProduct.price)
        // Product Image
        
        
        if(!showAddButton){
            if addButton != nil {
                addButton.removeFromSuperview()
            }
            storeNameLabel.alpha = 1
        } else {
            if storeNameLabel != nil {
                storeNameLabel.removeFromSuperview()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
