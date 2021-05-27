//
//  StoreTypeCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

class RegionCell: UITableViewCell {

    @IBOutlet var regionLabel: UILabel!
    
    var region: RegionModel!
    
    var selectedRegion: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureUI(){
        regionLabel.text = region.name
        regionLabel.textColor = selectedRegion ? UIColor(named: "Yellow") : .label
    }
}
