//
//  Constants.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct K {
    
    static let Host = "http://192.168.1.187/api"
    
    struct Request {
        static let Store = "store"
        
        struct Grocery {
            static let Categories = "grocery"
            
            static let Products = "grocery/products"
            static let ProductsFavourite = "favourite"
            
            static let Product = "product"
            static let Favourites = "favourites"
            static let FavouritesDelete = "favourites/delete"
            
            static let Reviews = "reviews"
            static let ReviewShow = "review"
            static let ReviewCreate = "review/create"
            static let ReviewDelete = "review/delete"
            
            static let Promotion = "promotion"
            
        }
        
        struct Lists {
            static let List = "list"
            static let ListCreate  = "list/create"
            static let ListDelete  = "list/delete"
            static let ListUpdate  = "list/update"
            static let ListRestart = "list/restart"
            
            static let ItemUpdate = "item/update"
            static let ItemDelete = "item/delete"
            static let ItemCreate = "item/create"
        }
    }
    
    struct Paths {
        static let showGroceryItem = "showGroceryItem"
        static let showIngredients = "showIngredients"
        static let favouritesToGroceryItem = "favouritesToGroceryItem"
        static let settingsToChangePassword = "settingsToChangePassword"
    }
    
    struct Sections {
        struct ListHeader {
            static let SectionIdentifier = "ResuableListSectionHeader"
            static let SectionNibName    = "ListSectionHeader"
        }
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

        struct ListCell {
            static let CellIdentifier = "ReusableListsTableViewCell"
            static let CellNibName    = "ListsTableViewCell"
        }
        
        struct ListItemCell {
            static let CellIdentifier = "ReusableListItemTableViewCell"
            static let CellNibName    = "ListItemTableViewCell"
        }
        
    }
    
}
