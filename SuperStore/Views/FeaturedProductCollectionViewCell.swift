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
    
    var loading: Bool = true
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet var ratingView: CosmosView!
    @IBOutlet var parentRatingView: UIView!
    
    var loadingViews:[UIView] {
        return [
            foodImage,
            productLabel,
            foodPriceLabel,
            parentRatingView
        ]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureUI(){
        
        if loading {
            startLoading()
        } else {
            stopLoading()
        }
        
        if product != nil {
            foodImage.downloaded(from: product!.image)
            productLabel.text = product!.name
            
            let price = String(format: "%.2f",product!.price )
            foodPriceLabel.text = "£\(price)"
            
            ratingView.rating = Double(product!.avg_rating)
            ratingView.text = "\(product!.total_reviews_count)"
        }
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
