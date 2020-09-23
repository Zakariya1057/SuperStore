//
//  SearchTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 29/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

enum SearchType: String {
    case store
    case product
    case childCategory
    case parentCategory
}

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentImage: UIImageView!
    
    var search: SearchModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    func configureUI(){
        
        let searchName: String     = search!.name
        nameLabel.text = searchName
        
//        let searchType: SearchType = search!.type
        
//        if searchType == .product {
//            contentImage.image = UIImage(named: "Chicken")
//        } else {
//            contentImage.image = UIImage(named: "LidlLogo")
//        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
