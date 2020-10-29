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
    
    var loading: Bool = true
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet var nameView: UIView!
    @IBOutlet weak var foodPriceLabel: UILabel!
    
    var loadingViews:[UIView] {
        return [
            foodImage,
            productLabel,
            foodPriceLabel
        ]
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
