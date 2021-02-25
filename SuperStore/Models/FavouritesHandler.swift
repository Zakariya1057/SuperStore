//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

protocol FavouritesDelegate {
    func contentLoaded(products: [ProductModel])
    func errorHandler(_ message:String)
    func logOutUser()
}

struct FavouritesHandler {
    
    var delegate: FavouritesDelegate?
    
    let requestHandler = RequestHandler()
    
    let productPath = K.Request.Grocery.Product
    
    func request(){
        let urlString = "\(K.Host)/\(K.Request.Grocery.Favourites)"
        requestHandler.getRequest(url: urlString, complete: processResults,error:processError,logOutUser: logOutUser)
    }
    
    func update(productID: Int, favourite: Bool){
        let productFavourite = K.Request.Grocery.ProductsFavourite
        let urlString = "\(K.Host)/\(productPath)/\(productID)/\(productFavourite)"
        requestHandler.postRequest(url: urlString, data: ["favourite": favourite], complete: { _ in }, error: processError,logOutUser: logOutUser)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            let decoder = JSONDecoder()
            let data = try decoder.decode(FavouritesDataResponse.self, from: data)
            let products_list = data.data
            
            var products:[ProductModel] = []
            
            for product in products_list {
                
                products.append(
                    ProductModel(id: product.id, name: product.name, smallImage: product.small_image, largeImage: product.large_image, description: product.description, quantity: 0, price: product.price, avgRating: product.avg_rating, totalReviewsCount: product.total_reviews_count, promotion: nil, storage: product.storage, weight: product.weight, parentCategoryId: product.parent_category_id, parentCategoryName: product.parent_category_name, childCategoryName: nil,dietaryInfo: product.dietary_info, allergenInfo: product.allergen_info, brand: product.brand, reviews: [], favourite: true, monitoring: nil, ingredients: [], recommended: []))
            }
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded(products: products)
            }

        } catch {
            processError("Decoding Data Error: \(error)")
        }

    }
    
    func logOutUser(){
        self.delegate?.logOutUser()
    }
    
    func processError(_ message:String){
        print(message)
        self.delegate?.errorHandler(message)
    }
}

extension FavouritesHandler {
    
    func addToFavourite(_ products: [ProductModel]){
        
        let realm = try! Realm()
        
        try! realm.write() {
            
            // Removing All Favourites
            let productsHistory = realm.objects(ProductHistory.self).filter("favourite = true")
            for product in productsHistory {
                product.favourite = false
            }
            
            for product in products.reversed() {
                let productHistory = realm.objects(ProductHistory.self).filter("id = \(product.id)").first
                
                if productHistory == nil {
                    product.favourite = true
                    realm.add(product.getRealmObject())
                } else {
                    // Updating product details
                    productHistory!.name = product.name
                    productHistory!.favourite = true
                    productHistory!.smallImage = product.smallImage
                    productHistory!.largeImage = product.largeImage
                    productHistory!.avgRating = product.avgRating
                    productHistory!.totalReviewsCount = product.totalReviewsCount
                    productHistory!.updatedAt = Date()
                }
                
            }
            
        }
        
    }
    
}
