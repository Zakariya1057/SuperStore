//
//  Constants.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct K {
    
//    Live
    static let Host = "http://18.132.201.151:8080/api"
    
//    Dev
//    static let Host = "http://192.168.1.187/api"
    
    struct Request {
        static let Store = "store"
        
        static let Home = "home"
        
        struct Grocery {
            static let Categories = "grocery"
            
            static let Products = "grocery/products"
            static let ProductsFavourite = "favourite"
            
            static let Product = "product"
            static let Favourites = "favourites"
            static let ProductMonitor = "monitor"
            
            static let FavouritesDelete = "favourites/delete"
            
            static let Promotion = "promotion"
            
        }
        
        struct Search {
            static let Suggestions = "search/suggestions"
            static let Results = "search/results"
        }
        
        struct User {
            static let Register = "user/register"
            static let Login = "user/login"
            static let Update = "user/update"
            static let Delete = "user/delete"
            static let LogOut = "user/logout"
            
            static let SendResetCode = "user/reset/send-code"
            static let ValidateResetCode = "user/reset/validate-code"
            static let ResetPassword = "user/reset/password"
        }
        
        struct Reviews {
            static let Reviews = "reviews"
            static let ReviewShow = "review"
            static let ReviewCreate = "review/create"
            static let ReviewDelete = "review/delete"
        }
        
        struct Lists {
            static let List = "list"
            static let ListCreate  = "create"
            static let ListDelete  = "delete"
            static let ListUpdate  = "update"
            static let ListRestart = "restart"
            
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
        
        struct HomeHeader {
            static let SectionIdentifier = "ResuableHomeSectionHeader"
            static let SectionNibName    = "HomeSectionHeader"
        }
    }
    
    struct Collections {
        struct ProductCollectionCell {
            static let CellIdentifier = "ReusableProductCollectionViewCell"
            static let CellNibName    = "ProductCollectionViewCell"
        }
        
        struct OfferCollectionCell {
            static let CellIdentifier = "ReusableOfferCollectionViewCell"
            static let CellNibName    = "OfferCollectionViewCell"
        }
        
        struct FeaturedProductsCollecionCell {
            static let CellIdentifier = "ReusableFeaturedProductCollectionViewCell"
            static let CellNibName    = "FeaturedProductCollectionViewCell"
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
        

        struct FeaturedProductCell {
            static let CellIdentifier = "ReusableFeaturedProductTableViewCell"
            static let CellNibName    = "FeaturedProductTableViewCell"
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
        
        struct ListsProgressCell {
            static let CellIdentifier = "ReusableListsProgressTableViewCell"
            static let CellNibName    = "ListsProgressTableViewCell"
        }
        
        struct OffersCell {
            static let CellIdentifier = "ReusableOffersTableViewCell"
            static let CellNibName    = "OffersTableViewCell"
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
        
        struct RefineCell {
            static let CellIdentifier = "ReusableRefineTableViewCell"
            static let CellNibName    = "RefineTableViewCell"
        }
        
        struct LoginToUseTableCell {
            static let CellIdentifier = "ReusableLoginToUseTableViewCell"
            static let CellNibName    = "LoginToUseTableViewCell"
        }
        
    }
    
}
