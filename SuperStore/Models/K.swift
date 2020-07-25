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
        static let showIngredients = "showIngredients"
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
        
        struct SimilarCell {
            static let CellIdentifier = "ReusableSimilarCollectionViewCell"
            static let CellNibName    = "SimilarCollectionViewCell"
        }
        
    }
}
