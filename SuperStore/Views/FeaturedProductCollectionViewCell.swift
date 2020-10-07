//
//  FeaturedProductCollectionViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 07/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import Cosmos

class FeaturedProductCollectionViewCell: UICollectionViewCell {
    var product: ProductModel?
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet var ratingView: CosmosView!
    
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
            
            ratingView.rating = Double(product!.avg_rating ?? 0)
            ratingView.text = "\(product!.total_reviews_count ?? 0)"
        }
    }

}
