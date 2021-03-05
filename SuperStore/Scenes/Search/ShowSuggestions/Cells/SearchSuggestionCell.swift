//
//  SearchTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 29/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class SearchSuggestionCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    var suggestion: SuggestionModel?
    
    @IBOutlet var nameView: UIView!
    
    var loadingViews: [UIView] {
        return [nameView]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureUI(){
        stopLoading()
        
        if let suggestion = suggestion {
            nameLabel.text = suggestion.name
        }
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