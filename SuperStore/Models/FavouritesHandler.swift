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
//    func errorHandler(_ message:String)
}

struct FavouritesHandler {
    
    var delegate: FavouritesDelegate?
    
    let requestHandler = RequestHandler()
    
    func request(){
        let url_string = "\(K.Host)/\(K.Request.Grocery.Favourites)"
        requestHandler.getRequest(url: url_string, complete: processResults,error:processError)
    }
    
    func delete(product_id: Int){
        let productHandler = ProductDetailsHandler()
        productHandler.favourite(product_id: product_id,product_data: ["favourite": "false"])
    }
    
    func processResults(_ data:Data){
        
        do {
            
            print("Processing Results")
            
            let decoder = JSONDecoder()
            let data = try decoder.decode(FavouritesDataResponse.self, from: data)
            let products_list = data.data
            
            var products:[ProductModel] = []
            
            for product_item in products_list {
                products.append(ProductModel(id: product_item.id, name: product_item.name, image: product_item.small_image, description: product_item.description, quantity: 0, weight: product_item.weight, price: product_item.price, location: "", avg_rating: product_item.avg_rating, total_reviews_count: product_item.total_reviews_count))
            }
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded(products: products)
            }

        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func processError(_ message:String){
//        self.delegate?.errorHandler(message)
    }
}
