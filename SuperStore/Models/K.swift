//
//  Constants.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct K {
    struct Paths {
        static let showGroceryItem = "showGroceryItem"
    }
    
    struct Cells {
        
        struct ReviewCell {
            static let CellIdentifier = "ReusableReviewTableCell"
            static let CellNibName    = "ReviewTableViewCell"
        }

        struct GroceryCell {
            static let CellIdentifier = "ReusableGroceryTableViewCell"
            static let CellNibName    = "GroceryTableViewCell"
        }
        
    }
}
