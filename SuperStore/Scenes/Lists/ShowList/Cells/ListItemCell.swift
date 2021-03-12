//
//  ListItemTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 30/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ListItemCell: UITableViewCell {
    
    @IBOutlet var loadingViews: [UIView]!
    
    var loading: Bool = true {
        didSet {
            loading ? startLoading() : stopLoading()
        }
    }

    var itemCheckboxPressed: ((ShowList.DisplayedListItem) -> Void)? = nil
    
    @IBOutlet var checkBoxButton: UIButton!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    var item: ShowList.DisplayedListItem!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureUI(){
        displayName()
        priceLabel.text = item.totalPrice
        showCheckBox()
    }
    
    func displayName(){
        let name = item.name
        let quantity = String(item.quantity)
        
        nameLabel.attributedText = NSMutableAttributedString().bold(quantity).normal(" x " + name)
    }
    
    @IBAction func checkBoxButtonPressed(_ sender: UIButton) {
        item.tickedOff = !item.tickedOff
        
        if let itemCheckboxPressed = itemCheckboxPressed {
            itemCheckboxPressed(item)
        }
        
        showCheckBox()
    }
    
}

extension ListItemCell {
    func showCheckBox(){
        if !item.tickedOff {
            checkBoxButton.tintColor = .label
            checkBoxButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else {
            checkBoxButton.tintColor = UIColor(named: "LogoBlue")
            checkBoxButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
    }
}

extension ListItemCell {
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
