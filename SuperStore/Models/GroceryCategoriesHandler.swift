//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol GroceriesCategoriesDelegate {
    func contentLoaded(categories: [GrandParentCategoryModel])
    func errorHandler(_ message:String)
}

struct GroceryCategoriesHandler {
    
    var delegate: GroceriesCategoriesDelegate?
    
    let requestHandler = RequestHandler()
    
    func request(store_type_id: Int){
        // Get All Categories - Grand Parent Categories, Parent Categories
        let host_url = K.Host
        let grocery_path = K.Request.Grocery.Categories
        let url_string = "\(host_url)/\(grocery_path)/\(store_type_id)"
        requestHandler.getRequest(url: url_string, complete: processResults,error:processError)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            print("Processing Results")
            
            let decoder = JSONDecoder()
            let grocery_data = try decoder.decode(GroceryCategoriesResponseData.self, from: data)
            let grocery_categories_list = grocery_data.data
            
//            print(groceryDetails)
            var grocery_categories:[GrandParentCategoryModel] = []
            
            for category in grocery_categories_list {
                let child_categories_list = category.child_categories
                
                var parent_categories:[ParentCategoryModel] = []
                
                for child_category in child_categories_list {
                    parent_categories.append( ParentCategoryModel(id: child_category.id, name: child_category.name, child_categories: []) )
                }
                
                grocery_categories.append( GrandParentCategoryModel(id: category.id, name: category.name, child_categories: parent_categories) )
            }
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded(categories: grocery_categories)
            }

            
        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func processError(_ message:String){
        self.delegate?.errorHandler(message)
    }
}
