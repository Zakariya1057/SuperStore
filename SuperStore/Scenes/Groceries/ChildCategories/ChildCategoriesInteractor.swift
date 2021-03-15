//
//  ChildCategoriesInteractor.swift
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

protocol ChildCategoriesBusinessLogic
{
    func getCategories(request: ChildCategories.GetCategories.Request)
    
    func getListItems(request: ChildCategories.GetListItems.Request)
    func createListItem(request: ChildCategories.CreateListItem.Request)
    func updateListItem(request: ChildCategories.UpdateListItem.Request)
    
    var selectedListID: Int? { get set }
    var selectedProductStoreTypeID: Int? { get set }
}

protocol ChildCategoriesDataStore
{
    var parentCategoryID: Int { get set }
    var storeTypeID: Int { get set }
    var selectedListID: Int? { get set }
    var selectedProductStoreTypeID: Int? { get set }
}

class ChildCategoriesInteractor: ChildCategoriesBusinessLogic, ChildCategoriesDataStore
{
    var presenter: ChildCategoriesPresentationLogic?

    var groceryWorker: GroceryWorker = GroceryWorker(groceryAPI: GroceryAPI())
    var listItemWorker: ListItemWorker = ListItemWorker(listItemAPI: ListItemAPI())
    
    var selectedListID: Int?
    
    var parentCategoryID: Int = 1
    var storeTypeID: Int = 1
    
    var selectedProductStoreTypeID: Int?

    func getCategories(request: ChildCategories.GetCategories.Request)
    {
        groceryWorker.getChildCategories(parentCategoryID: parentCategoryID) { (categories: [ChildCategoryModel], error: String?) in
            let response = ChildCategories.GetCategories.Response(categories: categories, error: error)
            self.presenter?.presentCategories(response: response)
        }
    }
}

extension ChildCategoriesInteractor {
    func getListItems(request: ChildCategories.GetListItems.Request){
        if let selectedListID = selectedListID {
            listItemWorker.getItems(listID: selectedListID) { (listItems: [ListItemModel]) in
                let response = ChildCategories.GetListItems.Response(listItems: listItems)
                self.presenter?.presentListItems(response: response)
            }
        }
    }
    
    func createListItem(request: ChildCategories.CreateListItem.Request){
        let listID: Int = request.listID
        let productID: Int = request.productID
        let parentCategoryID: Int = request.parentCategoryID
        let section: Int = request.section
        
        listItemWorker.createItem(listID: listID, productID: productID, parentCategoryID: parentCategoryID) { (listItem: ListItemModel?, error: String?) in
            let response = ChildCategories.CreateListItem.Response(section: section, listItem: listItem, error: error)
            self.presenter?.presentListItemCreated(response: response)
        }
    }
    
    func updateListItem(request: ChildCategories.UpdateListItem.Request){
        let listID: Int = request.listID
        let productID: Int = request.productID
        let quantity: Int = request.quantity
        
        listItemWorker.updateItem(listID: listID, productID: productID, quantity: quantity, tickedOff: false) { (error: String?) in
            let response = ChildCategories.UpdateListItem.Response(error: error)
            self.presenter?.presentListItemUpdated(response: response)
        }
    }
}
