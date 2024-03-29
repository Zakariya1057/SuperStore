//
//  ParentCategoriesInteractor.swift
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

protocol ParentCategoriesBusinessLogic
{
    func getCategories(request: ParentCategories.GetCategories.Request)
    var selectedListID: Int? { get set }
}

protocol ParentCategoriesDataStore
{
    var categories: [ParentCategoryModel] { get set }
    var title: String { get set }
    
    var selectedListID: Int? { get set }
    var supermarketChainID: Int { get set }
}

class ParentCategoriesInteractor: ParentCategoriesBusinessLogic, ParentCategoriesDataStore
{
    var presenter: ParentCategoriesPresentationLogic?
    var groceryWorker: GroceryWorker = GroceryWorker(groceryAPI: GroceryAPI())
    
    var selectedListID: Int?
    var supermarketChainID: Int = 1
    
    var title: String = ""
    var categories: [ParentCategoryModel] = []

    func getCategories(request: ParentCategories.GetCategories.Request)
    {
        let response = ParentCategories.GetCategories.Response(categories: categories, title: title)
        presenter?.presentCategories(response: response)
    }
}
