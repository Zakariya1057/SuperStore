//
//  nutrionSectionHeader.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 20/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

class NutrionSectionHeader: UITableViewHeaderFooterView {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var percentageLabel: UILabel!
    
    var nutrition: NutritionModel!
    
    func configureUI(){
        nameLabel.text = nutrition.name
        weightLabel.text = nutrition.grams
        percentageLabel.text = nutrition.percentage
    }


}
