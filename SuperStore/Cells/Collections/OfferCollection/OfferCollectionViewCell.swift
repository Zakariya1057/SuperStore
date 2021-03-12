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
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var loadingViews: [UIView]!
    
    var loading: Bool = true {
        didSet {
            loading ? startLoading() : stopLoading()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureUI() {
        if promotion != nil {
            let details = promotion!.name.components(separatedBy: " - ")
            
            let name = details[0]
            let price = details[1]
            
            nameLabel.text = name
            priceLabel.text = price
        }
    }
    
}

extension OfferCollectionViewCell {
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
