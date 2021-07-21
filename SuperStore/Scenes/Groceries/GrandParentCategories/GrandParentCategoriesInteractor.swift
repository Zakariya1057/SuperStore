//
//  GrandParentCategoriesInteractor.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol GrandParentCategoriesBusinessLogic
{
    func getCategories(request: GrandParentCategories.GetCategories.Request)
    var selectedListID: Int? { get set }
}

protocol GrandParentCategoriesDataStore
{
    var supermarketChainID: Int { get set }
    var categories: [GrandParentCategoryModel] { get set }
    var selectedListID: Int? { get set }
}

class GrandParentCategoriesInteractor: GrandParentCategoriesBusinessLogic, GrandParentCategoriesDataStore
{
    var presenter: GrandParentCategoriesPresentationLogic?
    var groceryWorker: GroceryWorker = GroceryWorker(groceryAPI: GroceryAPI())
    
    var userSession = UserSessionWorker()
    
    var selectedListID: Int?
    
    var supermarketChainID: Int = 1
    var categories: [GrandParentCategoryModel] = []
    
    func getCategories(request: GrandParentCategories.GetCategories.Request)
    {
        groceryWorker.getGrandParentCategories(companyID: 2) { (categories: [GrandParentCategoryModel], error: String?) in
            
            var response = GrandParentCategories.GetCategories.Response(categories: categories, error: error)
            
            if error != nil {
                response.offline = !self.userSession.isOnline()
            } else {
                self.categories = categories
            }
            
            self.presenter?.presentCategories(response: response)
        }
    }
}
