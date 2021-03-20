//
//  ListItemWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 04/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ListItemWorker {
    var listItemAPI: ListItemRequestProtocol
    var listItemStore: ListItemStoreProtocol
    
    var userSession = UserSessionWorker()
    
    init(listItemAPI: ListItemRequestProtocol) {
        self.listItemAPI = listItemAPI
        self.listItemStore = ListItemRealmStore()
    }
    
    func getItems(listID: Int, completionHandler: @escaping (_ listItems: [ListItemModel]) -> Void ){
        completionHandler( listItemStore.getListItems(listID: listID) )
    }
    
    func deleteItem(listID: Int, productID: Int, completionHandler: @escaping (_ error: String?) -> Void){
        
        if !userSession.isOnline() {
            listItemStore.deleteListItem(listID: listID, productID: productID)
        }
        
        listItemAPI.deleteItem(listID: listID, productID: productID) { (error: String?) in
            if error == nil {
                self.listItemStore.deleteListItem(listID: listID, productID: productID)
            }
            completionHandler(error)
        }
    }

    func createItem(listID: Int, product: ProductModel, completionHandler: @escaping (_ listItem: ListItemModel?, _ error: String?) -> Void){
        
        let savedListItem = listItemStore.getListItem(listID: listID, productID: product.id)
        completionHandler(savedListItem, nil)
        
        if savedListItem == nil, !userSession.isOnline() {
            let listItem = ListItemModel(
                id: 0,
                name: product.name,
                productID: product.id,
                image: product.largeImage,
                price: product.price,
                currency: product.currency,
                totalPrice: product.price,
                quantity: 1,
                weight: nil,
                promotion: product.promotion,
                tickedOff: false
            )
            
            print("Create List Item")
            
            listItemStore.createListItem(listID: listID, listItem: listItem, product: product)
        }
        
        listItemAPI.createItem(listID: listID, productID: product.id, parentCategoryID: product.parentCategoryID!) { (listItem: ListItemModel?, error: String?) in
            if let listItem = listItem {
                self.listItemStore.createListItem(listID: listID, listItem: listItem, product: product)
            }
            
            // Only show reflected quantity, if not found locally saved
            completionHandler(savedListItem == nil ? listItem : nil, error)
        }
    }
    
    func getListItem(listID: Int, productID: Int, completionHandler: @escaping (_ listItem: ListItemModel?) -> Void) {
        let item = listItemStore.getListItem(listID: listID, productID: productID)
        completionHandler(item)
    }
    
    func updateItem(listID: Int, productID: Int, quantity: Int, tickedOff: Bool, totalPrice: Double? = nil, completionHandler: @escaping (_ error: String?) -> Void){
        
        // If only wait to see if server responds successfully before updating.
        if !userSession.isOnline() {
            self.listItemStore.updateListItem(
                listID: listID,
                productID: productID,
                quantity: quantity,
                tickedOff: tickedOff,
                totalPrice: totalPrice
            )
        }
        
        listItemAPI.updateItem(listID: listID, productID: productID, quanity: quantity, tickedOff: tickedOff) { [self] (error: String?) in
            if error == nil {
                self.listItemStore.updateListItem(
                    listID: listID,
                    productID: productID,
                    quantity: quantity,
                    tickedOff: tickedOff,
                    totalPrice: totalPrice
                )
            }
            
            completionHandler(error)
        }
    }
}

protocol ListItemRequestProtocol {
    func createItem(listID: Int, productID: Int, parentCategoryID: Int, completionHandler: @escaping ( ListItemModel?, _ error: String?) -> Void)
    func updateItem(listID: Int, productID: Int, quanity: Int, tickedOff: Bool, completionHandler: @escaping ( _ error: String?) -> Void)
    func deleteItem(listID: Int, productID: Int, completionHandler: @escaping ( _ error: String?) -> Void)
}

protocol ListItemStoreProtocol {
    func getListItems(listID: Int) -> [ListItemModel]
    func getListItem(listID: Int, productID: Int) -> ListItemModel?
    func updateListItem(listID: Int, productID: Int, quantity: Int, tickedOff: Bool, totalPrice: Double?)
    func createListItem(listID: Int, listItem: ListItemModel, product: ProductModel?)
    func deleteListItem(listID: Int, productID: Int)
}
