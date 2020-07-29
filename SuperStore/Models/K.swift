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
        
        struct ProductCollectionCell {
            static let CellIdentifier = "ReusableProductCollectionViewCell"
            static let CellNibName    = "ProductCollectionViewCell"
        }
        
        struct ProductCell {
            static let CellIdentifier = "ReusableProductTableViewCell"
            static let CellNibName    = "ProductTableViewCell"
        }
        
        struct ListPriceUpdateCell {
            static let CellIdentifier = "ReusableListPriceUpdateTableViewCell"
            static let CellNibName    = "ListPriceUpdateTableViewCell"
        }
        
        struct StoreMapCell {
            static let CellIdentifier = "ReusableStoresMapTableViewCell"
            static let CellNibName    = "StoresMapTableViewCell"
        }
        
        struct SearchCell {
            static let CellIdentifier = "ReusableSearchTableViewCell"
            static let CellNibName    = "SearchTableViewCell"
        }
        
        struct StoresResultsCell {
            static let CellIdentifier = "ReusableStoresResultsTableViewCell"
            static let CellNibName    = "StoresResultsTableViewCell"
        }
        
    }
    
}
