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
    
    var loading: Bool = true
    
    init(title: String, groceriesPressed: @escaping () -> Void) {
        self.title = title
        self.groceriesPressed = groceriesPressed
        
        let groceryCell = items.first! as! GroceriesElementModel
        groceryCell.groceriesPressed = groceriesPressed
    }
}

class GroceriesElementModel: HomeElementItemModel {
    var loading: Bool = false
    var groceriesPressed: (() -> Void)? = nil
}

class GroceriesCell: UITableViewCell, HomeElementCell {
    
    var groceriesPressed: (() -> Void)? = nil
    
    func configure(model elementModel: HomeElementItemModel) {
        guard let model = elementModel as? GroceriesElementModel else {
            print("Unable to cast model as GroceriesElementModel: \(elementModel)")
            return
        }
        
        self.groceriesPressed = model.groceriesPressed
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func groceriesButtonPressed(_ sender: Any) {
        if let groceriesPressed = groceriesPressed {
            groceriesPressed()
        }
    }
    
}
