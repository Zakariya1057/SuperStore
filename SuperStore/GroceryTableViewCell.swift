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
}

class GroceryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storeNameLabel: UILabel!
    
    var delegate:GroceryDelegate?
    
    var product: ProductModel?
    
    var showAddButton:Bool = true
    var showStoreName: Bool = true
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewView: CosmosView!
    
    @IBAction func groceryAddClicked(_ sender: Any) {
        self.delegate?.addToList(self.product!)
    }
    
    func configureUI(){
        let current_product = product!
        
        productNameLabel.text = current_product.name
        priceLabel.text = "£" + String(format: "%.2f", current_product.price)
        
        productImage.downloaded(from: current_product.image)
        
        if(!showAddButton){
            if addButton != nil {
                addButton.removeFromSuperview()
            }
            
            if showStoreName != false {
                storeNameLabel.alpha = 1
            }
            
        } else {
            if storeNameLabel != nil {
                storeNameLabel.removeFromSuperview()
            }
        }
        
        let rating = current_product.avg_rating ?? 0
        let num = current_product.total_reviews_count ?? 0
        
        reviewView.rating = rating
        reviewView.text = "(\(num))"
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
