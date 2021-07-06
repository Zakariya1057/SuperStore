//
//  StoreTypeCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

class StoreTypeCell: UITableViewCell {

    @IBOutlet var storeButton: UIButton!
    
    @IBOutlet var buttonView: UIView!
    var selectedStoreType: Bool = false
    
    var supermarketChain: SupermarketChain!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI(){
        storeButton.setTitle(supermarketChain.name, for: .normal)
        storeButton.backgroundColor = supermarketChain.color
        
        if selectedStoreType {
            buttonView.layer.borderWidth = 2
            buttonView.layer.borderColor = UIColor.red.cgColor
        } else {
            buttonView.layer.borderWidth = 0
        }
    }
}
