//
//  ListWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 04/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ListWorker {
    private var listAPI: ListRequestProtocol
    private var listStore: ListStoreProtocol
    
    init(listAPI: ListRequestProtocol) {
        self.listAPI = listAPI
        self.listStore = ListRealmStore()
    }
    
    func createList(name: String, identifier: String, storeTypeID: Int, completionHandler: @escaping (_ error: String?) -> Void){
        listAPI.createList(name: name, identifier: identifier, storeTypeID: storeTypeID) { (list: ListModel?, error: String?) in
            if let list = list {
                self.listStore.createList(list: list, ignoreCategories: true)
            }
            
            completionHandler(error)
        }
    }

    func getList(listID: Int, completionHandler: @escaping ( _ list: ListModel?, _ error: String?) -> Void){
        // Preload List
        if let list = listStore.getList(listID: listID) {
            completionHandler(list, nil)
        }
        
        listAPI.getList(listID: listID) { (list: ListModel?, error: String?) in
            if let list = list {
                self.listStore.createList(list: list, ignoreCategories: false)
            }
            
            completionHandler(list, error)
        }
    }
    
    func getLists(storeTypeID: Int, completionHandler: @escaping ( _ lists: [ListModel], _ error: String?) -> Void){
        // Preload Lists
        let lists = listStore.getLists(storeTypeID: storeTypeID)
        completionHandler(lists, nil)
        
        listAPI.getLists { (lists: [ListModel], error: String?) in
            // Save lists
            for list in lists {
                self.listStore.createList(list: list, ignoreCategories: true)
            }
            
            completionHandler(lists, error)
        }
    }

    func updateList(listID: Int, name: String, storeTypeID: Int, completionHandler: @escaping (_ error: String?) -> Void){
        listAPI.updateList(listID: listID, name: name, storeTypeID: storeTypeID, completionHandler: completionHandler)
    }
    
    func restartList(listID: Int, completionHandler: @escaping (String?) -> Void){
        listAPI.restartList(listID: listID) { (error: String?) in
            if error == nil {
                self.listStore.restartList(listID: listID)
            }
            
            completionHandler(error)
        }
    }
    
    func deleteList(listID: Int, completionHandler: @escaping (String?) -> Void){
        listAPI.deleteList(listID: listID) { (error: String?) in
            if error == nil {
                self.listStore.deleteList(listID: listID)
            }
            
            completionHandler(error)
        }
    }
}

extension ListWorker {
    func updateListTotalPrice(listID: Int, totalPrice: Double, oldTotalPrice: Double?){
        listStore.updateListTotalPrice(listID: listID, totalPrice: totalPrice, oldTotalPrice: oldTotalPrice)
    }
}

protocol ListRequestProtocol {
    func getList(listID: Int, completionHandler: @escaping ( _ list: ListModel?, _ error: String?) -> Void)
    func getLists(completionHandler: @escaping ( _ lists: [ListModel], _ error: String?) -> Void)
    
    func createList(name: String, identifier: String, storeTypeID: Int, completionHandler: @escaping (_ list: ListModel?, _ error: String?) -> Void)
    func updateList(listID: Int, name: String, storeTypeID: Int, completionHandler: @escaping (String?) -> Void)
    func restartList(listID: Int, completionHandler: @escaping (String?) -> Void)
    func deleteList(listID: Int, completionHandler: @escaping (String?) -> Void)
}

protocol ListStoreProtocol {
    func getList(listID: Int) -> ListModel?
    func getLists(storeTypeID: Int) -> [ListModel]
    func createList(list: ListModel, ignoreCategories: Bool)
    func deleteList(listID: Int)
    
    func updateListTotalPrice(listID: Int, totalPrice: Double, oldTotalPrice: Double?)
    func restartList(listID: Int)
}
