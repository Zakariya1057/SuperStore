//
//  RequestLogin.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

class RequestLoginCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    var loginButtonPressed: (() -> Void?)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if let loginButtonPressed = loginButtonPressed {
            loginButtonPressed()
        }
    }
}
