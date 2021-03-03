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
    
    init(groceryAPI: GroceryRequestProtocol) {
        self.groceryAPI = groceryAPI
    }
    
    func getGrandParentCategories(storeTypeID: Int, completionHandler: @escaping ( _ categories: [GrandParentCategoryModel], _ error: String?) -> Void){
        groceryAPI.getGrandParentCategories(storeTypeID: storeTypeID, completionHandler: completionHandler)
    }
    
    func getChildCategories(grandParentCategoryID: Int, completionHandler: @escaping (_ categories: [ChildCategoryModel], _ error: String?) -> Void){
        groceryAPI.getChildCategories(grandParentCategoryID: grandParentCategoryID, completionHandler: completionHandler)
    }
}

protocol GroceryRequestProtocol {
    func getGrandParentCategories(storeTypeID: Int, completionHandler: @escaping ( _ categories: [GrandParentCategoryModel], _ error: String?) -> Void)
    func getChildCategories(grandParentCategoryID: Int, completionHandler: @escaping (_ categories: [ChildCategoryModel], _ error: String?) -> Void)
}
