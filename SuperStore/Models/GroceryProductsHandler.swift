//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol GroceriesProductsDelegate {
    func contentLoaded(categories: [GroceryProductsModel])
    func errorHandler(_ message:String)
}

struct GroceryProductsHandler {
    
    var delegate: GroceriesProductsDelegate?
    
    let requestHandler = RequestHandler()
    
    func request(parent_category_id: Int){
        // Get All Categories - Grand Parent Categories, Parent Categories
        let hostURL = K.Host
        let groceryPath = K.Request.Grocery.Products
        let urlString = "\(hostURL)/\(groceryPath)/\(parent_category_id)"
        requestHandler.getRequest(url: urlString, complete: processResults,error:processError)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            print("Processing Results")
            
            let decoder = JSONDecoder()
            let grocery_data = try decoder.decode(GroceryProductsResponseData.self, from: data)
            let grocery_categories_list = grocery_data.data
            
            var categories:[GroceryProductsModel] = []
            
            for category in grocery_categories_list {
                let products_list = category.products
                
                var products:[ProductModel] = []
                
                for product in products_list {
                    products.append( ProductModel(id: product.id, name: product.name, image: product.small_image, description: product.description, quantity: 0, weight: product.weight,parent_category_id: nil, parent_category_name: nil, price: product.price, location: "",avg_rating: product.avg_rating, total_reviews_count: product.total_reviews_count,discount: nil))
                }
                
                categories.append( GroceryProductsModel(id: category.id, name: category.name, products: products))
            }
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded(categories: categories)
            }

            
        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func processError(_ message:String){
        self.delegate?.errorHandler(message)
    }
}
