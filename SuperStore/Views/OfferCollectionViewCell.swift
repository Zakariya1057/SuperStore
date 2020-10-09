//
//  OfferCollectionViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 06/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class OfferCollectionViewCell: UICollectionViewCell {

    var discount: DiscountModel?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureUI() {
        if discount != nil {
            let details = discount!.name.components(separatedBy: " - ")
            
            let name = details[0]
            let price = details[1]
            
            nameLabel.text = name
            priceLabel.text = price
        }
    }
}
