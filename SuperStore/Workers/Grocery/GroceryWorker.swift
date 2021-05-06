//
//  GroceryWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class GroceryWorker {
    private var groceryAPI: GroceryRequestProtocol
    private var groceryStore: GroceryStoreProtocol
    
    var userSession = UserSessionWorker()
    
    init(groceryAPI: GroceryRequestProtocol) {
        self.groceryAPI = groceryAPI
        self.groceryStore = GroceryRealmStore()
    }
    
    func getGrandParentCategories(storeTypeID: Int, completionHandler: @escaping ( _ categories: [GrandParentCategoryModel], _ error: String?) -> Void){
        
        let categories = groceryStore.getGrandParentCategories(storeTypeID: storeTypeID)
        if categories.count > 0 {
            completionHandler(categories, nil)
        }
        
        groceryAPI.getGrandParentCategories(storeTypeID: storeTypeID) { (categories: [GrandParentCategoryModel], error: String?) in
            if error == nil {
                self.groceryStore.createCategories(categories: categories)
            }
            
            completionHandler(categories, error)
        }
    }
    
    func getChildCategories(parentCategoryID: Int, completionHandler: @escaping (_ categories: [ChildCategoryModel], _ error: String?) -> Void){
        
        let categories = groceryStore.getChildCategories(parentCategoryID: parentCategoryID)
        if categories.count > 0 {
            completionHandler(categories, nil)
        }
        
        groceryAPI.getChildCategories(parentCategoryID: parentCategoryID) { (categories: [ChildCategoryModel], error: String?) in
            if error == nil {
                self.groceryStore.createCategories(categories: categories)
            }
            
            completionHandler(categories, error)
        }
    }
    
    func getCategoryProducts(childCategoryID: Int, data: SearchQueryRequest, page: Int, completionHandler: @escaping (_ category: ChildCategoryModel?, _ error: String?) -> Void){
        
        if page == 1 && !data.refineSort {
            let category = groceryStore.getCategoryProducts(childCategoryID: childCategoryID)
            if let category = category, category.products.count > 0 {
                completionHandler(category, nil)
            }
        }

        groceryAPI.getCategoryProducts(childCategoryID: childCategoryID, data: data, page: page) { (category: ChildCategoryModel?, error: String?) in
            if error == nil {
                if let category = category {
                    self.groceryStore.createCategories(categories: [category])
                }
            }
            
            completionHandler(category, error)
        }
    }
}

protocol GroceryRequestProtocol {
    func getGrandParentCategories(storeTypeID: Int, completionHandler: @escaping ( _ categories: [GrandParentCategoryModel], _ error: String?) -> Void)
    func getChildCategories(parentCategoryID: Int, completionHandler: @escaping (_ categories: [ChildCategoryModel], _ error: String?) -> Void)
    func getCategoryProducts(childCategoryID: Int, data: SearchQueryRequest, page: Int, completionHandler: @escaping (ChildCategoryModel?, String?) -> Void)
}

protocol GroceryStoreProtocol {
    func createCategories(categories: [GrandParentCategoryModel])
    func createCategories(categories: [ChildCategoryModel])
    
    func getGrandParentCategories(storeTypeID: Int) -> [GrandParentCategoryModel]
    func getChildCategories(parentCategoryID: Int) -> [ChildCategoryModel]
    func getCategoryProducts(childCategoryID: Int) -> ChildCategoryModel?
    
    func createCategoryObject(category: ChildCategoryModel) -> ChildCategoryObject
    func createCategoryObject(category: ParentCategoryModel) -> ParentCategoryObject
    func createCategoryObject(category: GrandParentCategoryModel) -> GrandParentCategoryObject
}
