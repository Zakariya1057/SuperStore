//
//  StoresResultsTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 29/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class StoresResultsTableViewCell: UITableViewCell {

    var store: StoreModel?
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var openStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        // Initialization code
    }

    func configureUI(){
        if store != nil {
            nameLabel.text = store!.name
            
            let location = store!.location
            let address = [location.address_line1, location.address_line2, location.address_line3, location.city ]
            addressLabel.text = address.compactMap { $0 }.joined(separator: ", ")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
