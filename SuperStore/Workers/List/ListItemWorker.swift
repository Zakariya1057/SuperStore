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
    
    init(listItemAPI: ListItemRequestProtocol) {
        self.listItemAPI = listItemAPI
        self.listItemStore = ListItemRealmStore()
    }
    
    func deleteItem(listID: Int, productID: Int, completionHandler: @escaping (_ error: String?) -> Void){
        listItemAPI.deleteItem(listID: listID, productID: productID) { (error: String?) in
            if error == nil {
                self.listItemStore.deleteListItem(listID: listID, productID: productID)
            }
            completionHandler(error)
        }
    }

    func createItem(listID: Int, productID: Int, parentCategoryID: Int, completionHandler: @escaping (_ error: String?) -> Void){
        listItemAPI.createItem(listID: listID, productID: productID, parentCategoryID: parentCategoryID, completionHandler: completionHandler)
    }
    
    func updateItem(listID: Int, productID: Int, quantity: Int, tickedOff: Bool, completionHandler: @escaping (_ error: String?) -> Void){
        listItemAPI.updateItem(listID: listID, productID: productID, quanity: quantity, tickedOff: tickedOff) { [self] (error: String?) in
            if error == nil {
                self.listItemStore.updateListItem(
                    listID: listID,
                    productID: productID,
                    quantity: quantity,
                    tickedOff: tickedOff
                )
            }
            
            completionHandler(error)
        }
    }
}

protocol ListItemRequestProtocol {
    func deleteItem(listID: Int, productID: Int, completionHandler: @escaping ( _ error: String?) -> Void)
    func createItem(listID: Int, productID: Int, parentCategoryID: Int, completionHandler: @escaping ( _ error: String?) -> Void)
    func updateItem(listID: Int, productID: Int, quanity: Int, tickedOff: Bool, completionHandler: @escaping ( _ error: String?) -> Void)
}

protocol ListItemStoreProtocol {
    func updateListItem(listID: Int, productID: Int, quantity: Int, tickedOff: Bool)
    func createListItem(listID: Int, listItem: ListItemModel)
    func deleteListItem(listID: Int, productID: Int)
}
