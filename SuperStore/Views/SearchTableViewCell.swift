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
    
    var search: SearchModel?
    
    var loadingViews: [UIView] {
        return [nameLabel]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureUI(){
        stopLoading()
        let searchName: String = search!.name
        nameLabel.text = searchName
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func startLoading(){
        for item in loadingViews {
            item.isSkeletonable = true
            item.showAnimatedGradientSkeleton()
        }
    }
    
    func stopLoading(){
        for item in loadingViews {
            item.hideSkeleton()
        }
    }
    
}
