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
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
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
        
        if let promotion = promotion {
            let details = promotion.name.components(separatedBy: " - ")
            
            var title: String = ""
            var detail: String = ""
            
            if let promotionTitle = promotion.title {
                title = promotionTitle
                detail = promotion.name
            } else {
                if details.count > 1 {
                    title = details[0]
                    detail = details[1]
                } else {
                    title = promotion.name
                }
            }
            
            titleLabel.text = title
            detailLabel.text = detail
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
