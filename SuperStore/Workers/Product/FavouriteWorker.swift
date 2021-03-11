//
//  FavouriteWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class FavouriteWorker {
    var favouriteAPI: FavouriteRequestProtocol
    var productStore: ProductStoreProtocol
    
    init(favouriteAPI: FavouriteRequestProtocol) {
        self.favouriteAPI = favouriteAPI
        self.productStore = ProductRealmStore()
    }
    
    func updateFavourite(productID: Int, favourite: Bool, completionHandler: @escaping (_ error: String?) -> Void){
        favouriteAPI.updateFavourite(productID: productID, favourite: favourite) { (error: String?) in
            if error == nil {
                self.productStore.updateProductFavourite(productID: productID, favourite: favourite)
            }
            
            completionHandler(error)
        }
    }
    
    func getFavourites(completionHandler: @escaping (_ products: [ProductModel], _ error: String?) -> Void){
        
        let favourites = productStore.getFavouriteProducts()
        if favourites.count > 0 {
            completionHandler(favourites, nil)
        }
        
        favouriteAPI.getFavourites { (products: [ProductModel], error: String?) in
            if error == nil {
                self.productStore.clearFavourites()
                self.productStore.createProducts(products: products)
            }
            
            completionHandler(products, error)
        }
    }
    
    func deleteFavourite(productID: Int, completionHandler: @escaping (_ error: String?) -> Void){
        favouriteAPI.deleteFavourite(productID: productID) { (error: String?) in
            if error == nil {
                self.productStore.updateProductFavourite(productID: productID, favourite: false)
            }
            
            completionHandler(error)
        }
    }
    
}

protocol FavouriteRequestProtocol {
    func updateFavourite(productID: Int, favourite: Bool, completionHandler: @escaping (_ error: String?) -> Void)
    func getFavourites(completionHandler: @escaping (_ products: [ProductModel], _ error: String?) -> Void)
    func deleteFavourite(productID: Int, completionHandler: @escaping (_ error: String?) -> Void)
}
