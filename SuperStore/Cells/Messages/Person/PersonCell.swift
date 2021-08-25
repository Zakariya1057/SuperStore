//
//  MessagePeopleCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 24/08/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {

    var person: PersonModel!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureUI(){
        nameLabel.text = person.name
        messageLabel.text = person.message
//        dateLabel.text = "" // Date
    }
    
}
