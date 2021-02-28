//
//  ReviewTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 24/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import Cosmos

class ReviewCell: UITableViewCell {

    var review: ReviewModel?
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var reviewText: UILabel!
    @IBOutlet weak var usernameField:UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var loadingViews: [UIView] {
        return [ratingView,reviewText,usernameField,titleLabel]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI(){
        
        stopLoading()
        
        if let product_review = review {
            let rating: Double = Double(product_review.rating)
            
            ratingView.rating = rating
            
            titleLabel?.text = product_review.title
            usernameField.text = product_review.name
            reviewText.text = product_review.text
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
