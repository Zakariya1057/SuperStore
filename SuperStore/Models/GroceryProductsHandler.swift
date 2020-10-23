//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol GroceriesProductsDelegate {
    func contentLoaded(child_categories: [ChildCategoryModel])
    func errorHandler(_ message:String)
    func logOutUser()
}

struct GroceryProductsHandler {
    
    var delegate: GroceriesProductsDelegate?
    
    let requestHandler = RequestHandler()
    
    func request(parentCategoryId: Int){
        let urlString = "\(K.Host)/\(K.Request.Grocery.Products)/\(parentCategoryId)"
        requestHandler.getRequest(url: urlString, complete: processResults,error:processError,logOutUser: logOutUser)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            print("Processing Results")
            
            let decoder = JSONDecoder()
            let grocery_data = try decoder.decode(GroceryProductsResponseData.self, from: data)
            let grocery_categories_list = grocery_data.data
            
            var categories:[ChildCategoryModel] = []
            
            for category in grocery_categories_list {
                let products_list = category.products
                
                var products:[ProductModel] = []
                
                for product_item in products_list {
                    
                    products.append( ProductModel(id: product_item.id, name: product_item.name, image: product_item.small_image, quantity: 0, product_id: product_item.id, price: product_item.price, weight: product_item.weight, promotion: nil, description: product_item.description, favourite: product_item.favourite, avgRating: product_item.avg_rating, totalReviewsCount: product_item.total_reviews_count, parentCategoryId: product_item.parent_category_id, parentCategoryName: product_item.parent_category_name) )

                }
                
                categories.append( ChildCategoryModel(id: category.id, name: category.name, parentCategoryId: category.parent_category_id, products: products))
            }
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded(child_categories: categories)
            }

            
        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func logOutUser(){
        self.delegate?.logOutUser()
    }
    
    func processError(_ message:String){
        self.delegate?.errorHandler(message)
    }
}
