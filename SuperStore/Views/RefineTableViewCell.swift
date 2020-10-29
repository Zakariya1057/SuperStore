//
//  RefineTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class RefineTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var tickBoxImage: UIImageView!
    var name:String?
    var selectedOption: Bool = false
    
    var section: Int?
    var row: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI(){
        nameLabel.text = name ?? ""
        showCheckBox()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func checkBoxPressed(_ sender: UIButton) {
        selectedOption = !selectedOption
//        delegate?.optionSelected(section: section!, row: row!)
        showCheckBox()
    }
    
    func showCheckBox(){
        if !selectedOption {
            tickBoxImage.tintColor = .label
            tickBoxImage.image = UIImage(systemName: "circle")
        } else {
            tickBoxImage.tintColor = UIColor(named: "LogoBlue.Light")
            tickBoxImage.image = UIImage(systemName: "checkmark.circle")
        }
    }
    
}
