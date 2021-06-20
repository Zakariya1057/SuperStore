//
//  NutritionCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 20/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

class NutritionCell: UITableViewCell {

    var nutrion: ChildNutritionModel!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var percentageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI(){
//        nameLabel.text = nutrion.name
//        percentageLabel.text = nutrion.percentage
    }
    
}
