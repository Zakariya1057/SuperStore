//
//  FavouriteAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class FavouriteAPI: API, FavouriteRequestProtocol {
    
    func getFavourites(regionID: Int, supermarketChainID: Int, completionHandler: @escaping ([ProductModel], String?) -> Void) {
        let url = Config.Routes.Favourites + "?region_id=\(regionID)&supermarket_chain_id=\(supermarketChainID)"
        
        requestWorker.get(url: url) { (response: () throws -> Data) in
            do {
                let data = try response()
                let favouritesDataResponse =  try self.jsonDecoder.decode(FavouritesDataResponse.self, from: data)
                let products = self.createProductModels(favouritesDataResponse: favouritesDataResponse)
                completionHandler(products, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler([], errorMessage)
            } catch {
                print(error)
                completionHandler([], "Failed to get product. Decoding error, please try again later.")
            }
        }
    }
    
    func updateFavourite(productID: Int, favourite: Bool, completionHandler: @escaping (String?) -> Void) {
        let url = Config.Routes.Product.Show + String(productID) +  Config.Routes.Product.Favourite

        requestWorker.post(url: url, data: ["favourite": favourite]) { (response: () throws -> Data) in
            do {
                _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                print(error)
                completionHandler("Failed to get product. Decoding error, please try again later.")
            }
        }
    }
    
    func deleteFavourite(productID: Int, completionHandler: @escaping (_ error: String?) -> Void){
        let url = Config.Routes.Product.Show + String(productID) +  Config.Routes.Product.Favourite
        
        requestWorker.post(url: url, data: ["favourite": false]) { (response: () throws -> Data) in
            do {
                let _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                print(error)
                completionHandler("Failed to get product. Decoding error, please try again later.")
            }
        }
    }

    
}

extension FavouriteAPI {
    
    private func createProductModels(favouritesDataResponse: FavouritesDataResponse) -> [ProductModel] {
        let productsData = favouritesDataResponse.data
        
        return productsData.map { (product: ProductData) in
            return product.getProductModel()
        }
    }
}

