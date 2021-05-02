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
    
    var loading: Bool = true {
        didSet {
            loading ? startLoading() : stopLoading()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet var ratingView: CosmosView!
    
    @IBOutlet var loadingViews: [UIView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI(){
        
        if loading {
            startLoading()
        } else {
            stopLoading()
        }
        
        if let product = product {
            
            if let image = product.smallImage {
                imageView.downloaded(from: image)
            } else {
                imageView.noImage()
            }
            
            nameLabel.text = product.name
            priceLabel.text = product.getPrice()
            
            ratingView.rating = Double(product.avgRating)
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
