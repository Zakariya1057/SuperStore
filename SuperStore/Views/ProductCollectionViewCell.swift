//
//  SimilarCollectionViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    var product: ProductModel?
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var foodPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureUI(){
        if product != nil {
            foodImage.downloaded(from: product!.image)
            productLabel.text = product!.name
            
            let price = String(format: "%.2f",product!.price )
            foodPriceLabel.text = "£\(price)"
        }
    }

}
