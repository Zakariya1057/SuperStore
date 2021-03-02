//
//  RefineTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class RefineOptionCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tickBoxImage: UIImageView!

    var refineOption: RefineOptionModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI(){
        nameLabel.text = refineOption?.name
        showCheckBox()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func showCheckBox(){
        if ((refineOption?.checked) != nil) {
            tickBoxImage.tintColor = .label
            tickBoxImage.image = UIImage(systemName: "circle")
        } else {
            tickBoxImage.tintColor = UIColor(named: "LogoBlue.Light")
            tickBoxImage.image = UIImage(systemName: "checkmark.circle")
        }
    }
    
}
