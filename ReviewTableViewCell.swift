//
//  ReviewTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 24/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import Cosmos

class ReviewTableViewCell: UITableViewCell {

    var review: ReviewModel?
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var reviewText: UILabel!
    @IBOutlet weak var usernameField:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI(){
        if let product_review = review {
            let rating: Double = Double(product_review.rating)
            
            ratingView.rating = rating
            ratingView.text = "\(product_review.rating)/5"
            
            usernameField.text = product_review.name
            reviewText.text = product_review.text
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
