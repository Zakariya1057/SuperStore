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
    
    init(favouriteAPI: FavouriteRequestProtocol) {
        self.favouriteAPI = favouriteAPI
    }
    
    func updateFavourite(productID: Int, favourite: Bool, completionHandler: @escaping (_ error: String?) -> Void){
        favouriteAPI.updateFavourite(productID: productID, favourite: favourite, completionHandler: completionHandler)
    }
    
    func getFavourites(completionHandler: @escaping (_ products: [ProductModel], _ error: String?) -> Void){
        favouriteAPI.getFavourites(completionHandler: completionHandler)
    }
    
    func deleteFavourite(productID: Int, completionHandler: @escaping (_ error: String?) -> Void){
        favouriteAPI.deleteFavourite(productID: productID, completionHandler: completionHandler)
    }
    
}

protocol FavouriteRequestProtocol {
    func updateFavourite(productID: Int, favourite: Bool, completionHandler: @escaping (_ error: String?) -> Void)
    func getFavourites(completionHandler: @escaping (_ products: [ProductModel], _ error: String?) -> Void)
    func deleteFavourite(productID: Int, completionHandler: @escaping (_ error: String?) -> Void)
}
