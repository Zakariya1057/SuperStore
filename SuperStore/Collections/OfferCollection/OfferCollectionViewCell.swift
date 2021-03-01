//
//  OfferCollectionViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 06/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import SkeletonView

class OfferCollectionViewCell: UICollectionViewCell {

    var promotion: PromotionModel?
    var loading: Bool = true
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var parentView: UIView!
    
    var loadingViews:[UIView] {
        return [
            parentView,
        ]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureUI() {
        
        if loading {
            startLoading()
        } else {
            stopLoading()
        }
        
        if promotion != nil {
            let details = promotion!.name.components(separatedBy: " - ")
            
            let name = details[0]
            let price = details[1]
            
            nameLabel.text = name
            priceLabel.text = price
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
