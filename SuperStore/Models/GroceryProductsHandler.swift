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
            
            let decoder = JSONDecoder()
            let grocery_data = try decoder.decode(GroceryProductsResponseData.self, from: data)
            let grocery_categories_list = grocery_data.data
            
            var categories:[ChildCategoryModel] = []
            
            for category in grocery_categories_list {
                let products_list = category.products
                
                var products:[ProductModel] = []
                
                for product in products_list {
                    
                    products.append(
                        ProductModel(id: product.id, name: product.name, smallImage: product.small_image, largeImage: product.large_image, description: product.description, quantity: 0, price: product.price, avgRating: product.avg_rating, totalReviewsCount: product.total_reviews_count, promotion: nil, storage: product.storage, weight: product.weight, parentCategoryId: product.parent_category_id, parentCategoryName: product.parent_category_name, childCategoryName: nil, dietary_info: product.allergen_info, allergen_info: product.allergen_info, brand: product.brand, reviews: [], favourite: nil, monitoring: nil, ingredients: [], recommended: [])
                    )

                }
                
                categories.append( ChildCategoryModel(id: category.id, name: category.name, parentCategoryId: category.parent_category_id, products: products))
            }
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded(child_categories: categories)
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
