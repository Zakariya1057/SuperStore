//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol FavouritesDelegate {
    func contentLoaded(products: [ProductModel])
    func errorHandler(_ message:String)
}

struct FavouritesHandler {
    
    var delegate: FavouritesDelegate?
    
    let requestHandler = RequestHandler()
    
    let productPath = K.Request.Grocery.Product
    
    func request(){
        let url_string = "\(K.Host)/\(K.Request.Grocery.Favourites)"
        requestHandler.getRequest(url: url_string, complete: processResults,error:processError)
    }
    
    func update(product_id: Int, favourite: Bool){
        let productFavourite = K.Request.Grocery.ProductsFavourite
        let url_string = "\(K.Host)/\(productPath)/\(product_id)/\(productFavourite)"
        requestHandler.postRequest(url: url_string, data: ["favourite": String(favourite)], complete: { _ in }, error: processError)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            print("Processing Results")
            
            let decoder = JSONDecoder()
            let data = try decoder.decode(FavouritesDataResponse.self, from: data)
            let products_list = data.data
            
            var products:[ProductModel] = []
            
            for product_item in products_list {
                
                products.append( ProductModel(id: product_item.id, name: product_item.name, image: product_item.small_image, quantity: 1, product_id: product_item.id, price: product_item.price, weight: product_item.weight, promotion: nil, description: product_item.description, favourite: true, avg_rating: product_item.avg_rating!, total_reviews_count: product_item.total_reviews_count, parent_category_id: product_item.parent_category_id, parent_category_name: product_item.parent_category_name) )
            }
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded(products: products)
            }

        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func processError(_ message:String){
        self.delegate?.errorHandler(message)
    }
}
