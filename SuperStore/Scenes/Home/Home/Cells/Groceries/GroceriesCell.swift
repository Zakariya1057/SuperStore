//
//  GroceriesTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 23/04/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

class GroceriesGroupElement: HomeElementGroupModel {
    var title: String
    var type: HomeElementType = .groceries
    var items: [HomeElementItemModel] = [GroceriesElementModel()]
    
    var groceriesPressed: () -> Void
    var flyersPressed: () -> Void
    
    var showViewAllButton: Bool = false
    
    var loading: Bool = true
    
    init(title: String, groceriesPressed: @escaping () -> Void, flyersPressed: @escaping () -> Void) {
        self.title = title
        
        self.groceriesPressed = groceriesPressed
        self.flyersPressed = flyersPressed
        
        let groceryCell = items.first! as! GroceriesElementModel
        groceryCell.groceriesPressed = groceriesPressed
        groceryCell.flyersPressed = flyersPressed
    }
}

class GroceriesElementModel: HomeElementItemModel {
    var loading: Bool = false
    var groceriesPressed: (() -> Void)? = nil
    var flyersPressed: (() -> Void)? = nil
}

class GroceriesCell: UITableViewCell, HomeElementCell {
    
    @IBOutlet weak var browseButtonView: UIView!
    @IBOutlet var flyersButtonView: UIView!
    
    var groceriesPressed: (() -> Void)? = nil
    var flyersPressed: (() -> Void)? = nil
    
    func configure(model elementModel: HomeElementItemModel) {
        guard let model = elementModel as? GroceriesElementModel else {
            print("Unable to cast model as GroceriesElementModel: \(elementModel)")
            return
        }
        
        self.groceriesPressed = model.groceriesPressed
        self.flyersPressed = model.flyersPressed
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViewGesture()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupViewGesture(){
        let browseButtonPressed = UITapGestureRecognizer(target: self, action: #selector(groceriesButtonPressed))
        browseButtonView.addGestureRecognizer(browseButtonPressed)
        
        let flyersButtonPressed = UITapGestureRecognizer(target: self, action: #selector(flyersButtonPressed))
        flyersButtonView.addGestureRecognizer(flyersButtonPressed)
    }
    
    @objc func groceriesButtonPressed() {
        if let groceriesPressed = groceriesPressed {
            groceriesPressed()
        }
    }
    
    @objc func flyersButtonPressed() {
        if let flyersPressed = flyersPressed {
            flyersPressed()
            print("Reach")
        }
    }
    
}
