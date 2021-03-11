//
//  GroceryWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class GroceryWorker {
    var groceryAPI: GroceryRequestProtocol
    var groceryStore: GroceryStoreProtocol
    
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
                self.groceryStore.createCategories(categories: categories, storeTypeID: storeTypeID)
            }
            
            completionHandler(categories, error)
        }
    }
    
    func getChildCategories(storeTypeID: Int, parentCategoryID: Int, completionHandler: @escaping (_ categories: [ChildCategoryModel], _ error: String?) -> Void){
        
        let categories = groceryStore.getChildCategories(parentCategoryID: parentCategoryID)
        if categories.count > 0 {
            completionHandler(categories, nil)
        }
        
        groceryAPI.getChildCategories(parentCategoryID: parentCategoryID) { (categories: [ChildCategoryModel], error: String?) in
            if error == nil {
                self.groceryStore.createCategories(categories: categories, storeTypeID: storeTypeID, parentCategoryID: parentCategoryID)
            }
            
            completionHandler(categories, error)
        }
    }
}

protocol GroceryRequestProtocol {
    func getGrandParentCategories(storeTypeID: Int, completionHandler: @escaping ( _ categories: [GrandParentCategoryModel], _ error: String?) -> Void)
    func getChildCategories(parentCategoryID: Int, completionHandler: @escaping (_ categories: [ChildCategoryModel], _ error: String?) -> Void)
}

protocol GroceryStoreProtocol {
    func createCategories(categories: [GrandParentCategoryModel], storeTypeID: Int)
    func createCategories(categories: [ChildCategoryModel], storeTypeID: Int, parentCategoryID: Int)
    
    func getGrandParentCategories(storeTypeID: Int) -> [GrandParentCategoryModel]
    func getChildCategories(parentCategoryID: Int) -> [ChildCategoryModel]
    
    func createCategoryObject(category: ChildCategoryModel, storeTypeID: Int, parentCategoryID: Int) -> ChildCategoryObject
    func createCategoryObject(category: ParentCategoryModel, storeTypeID: Int) -> ParentCategoryObject
    func createCategoryObject(category: GrandParentCategoryModel, storeTypeID: Int) -> GrandParentCategoryObject
}
