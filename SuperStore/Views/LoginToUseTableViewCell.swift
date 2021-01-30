//
//  LoginToUseTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 29/01/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

protocol LoginPressedDelegate {
    func loginPressed()
}

class LoginToUseTableViewCell: UITableViewCell {

    @IBOutlet var headerLabel: UILabel!
    
    var delegate: LoginPressedDelegate?
    
    var page: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.headerLabel.text = "To add \(page) please Login"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.delegate?.loginPressed()
    }
}
