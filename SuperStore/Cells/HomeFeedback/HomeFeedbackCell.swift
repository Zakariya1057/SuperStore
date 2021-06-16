//
//  HomeFeedbackCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 16/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

class HomeFeedbackGroupElement: HomeElementGroupModel {

    var title: String
    var type: HomeElementType = .homeFeedback
    var items: [HomeElementItemModel] = [ HomeFeedbackElementModel() ]
    var chatButtonPressed: (() -> Void)? = nil
    
    var badgeNumber: Int = 0
    
    var showViewAllButton: Bool = false
    
    var loading: Bool = true
    
    init(title: String, chatButtonPressed: (() -> Void)?, badgeNumber: Int) {
        self.title = title
        self.chatButtonPressed = chatButtonPressed
        self.badgeNumber = badgeNumber
        
        configurePressed()
    }
    
    func configurePressed(){
        let items = items as! [HomeFeedbackElementModel]
        items.forEach { item in
            item.chatButtonPressed = chatButtonPressed
            item.badgeNumber = badgeNumber
        }
    }
}

class HomeFeedbackElementModel: HomeElementItemModel {
    var chatButtonPressed: (() -> Void)? = nil
    var loading: Bool = true
    var badgeNumber: Int = 0
}


class HomeFeedbackCell: UITableViewCell, HomeElementCell {

    var chatButtonPressed: (() -> Void)? = nil
    
    var loading: Bool = true
    
    @IBOutlet var badgeParentView: UIView!
    @IBOutlet var badgeView: UIView!
    @IBOutlet var badgeLabel: UILabel!
    
    var badgeNumber: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model elementModel: HomeElementItemModel) {
        guard let model = elementModel as? HomeFeedbackElementModel else {
            print("Unable to cast model as HomeFeedbackElementModel: \(elementModel)")
            return
        }
        
        self.chatButtonPressed = model.chatButtonPressed
        self.loading = model.loading
        self.badgeNumber = model.badgeNumber
        
        configureUI()
    }
    
    func configureUI(){
        setBadgeNumber()
    }
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        if let chatButtonPressed = chatButtonPressed {
            chatButtonPressed()
        }
    }
}

extension HomeFeedbackCell {
    func setBadgeViewBorder(){
        badgeView.layer.cornerRadius = 10
    }
    
    func setBadgeNumber(){
        if badgeNumber > 0 {
            badgeLabel.text = String(badgeNumber)
            badgeParentView.isHidden = false
            setBadgeViewBorder()
        } else {
            badgeParentView.isHidden = true
        }
    }
}
