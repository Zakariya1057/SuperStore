//
//  FeatureTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 15/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

class FacilityTableViewCell: UITableViewCell {

    var facility: Store.DisplayFacility!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureUI(){
        nameLabel.text = facility.name
        iconImageView.image = facility.icon
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
