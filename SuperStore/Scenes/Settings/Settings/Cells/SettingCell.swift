//
//  SettingCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 04/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    var icons: [String: UIImage?] = [
        "Name": UIImage(systemName: "person"),
        "Email": UIImage(systemName: "envelope"),
        "Password": UIImage(systemName: "lock"),
        "Store": UIImage(systemName: "cart"),
        "Notifications": UIImage(systemName: "bell"),
        "Feedback": UIImage(systemName: "bubble.left.and.bubble.right")
    ]
    
    @IBOutlet var iconImageView: UIImageView!
    
    @IBOutlet var keyLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    @IBOutlet var disclosureView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI(){
        let key: String = keyLabel.text ?? ""
        
        if let iconImage = icons[key]{
            iconImageView.image = iconImage
        }
    }
}
