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
    
    init(listItemAPI: ListItemRequestProtocol) {
        self.listItemAPI = listItemAPI
    }
    
    func deleteItem(listID: Int, productID: Int, completionHandler: @escaping (_ error: String?) -> Void){
        listItemAPI.deleteItem(listID: listID, productID: productID, completionHandler: completionHandler)
    }

    func createItem(listID: Int, productID: Int, parentCategoryID: Int, completionHandler: @escaping (_ error: String?) -> Void){
        listItemAPI.createItem(listID: listID, productID: productID, parentCategoryID: parentCategoryID, completionHandler: completionHandler)
    }
    
    func updateItem(listID: Int, productID: Int, quantity: Int, tickedOff: Bool, completionHandler: @escaping (_ error: String?) -> Void){
        listItemAPI.updateItem(listID: listID, productID: productID, quanity: quantity, tickedOff: tickedOff, completionHandler: completionHandler)
    }
}

protocol ListItemRequestProtocol {
    func deleteItem(listID: Int, productID: Int, completionHandler: @escaping ( _ error: String?) -> Void)
    func createItem(listID: Int, productID: Int, parentCategoryID: Int, completionHandler: @escaping ( _ error: String?) -> Void)
    func updateItem(listID: Int, productID: Int, quanity: Int, tickedOff: Bool, completionHandler: @escaping ( _ error: String?) -> Void)
}
