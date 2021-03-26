//
//  CreateListCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

class CreateListCell: UITableViewCell {

    var createListButtonPressed: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func createListButtonPressed(_ sender: Any) {
        if let createListButtonPressed = createListButtonPressed {
            createListButtonPressed()
        }
    }
    
}
