//
//  ListWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 04/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ListWorker {
    var listAPI: ListRequestProtocol
    var listStore: ListStoreProtocol
    
    init(listAPI: ListRequestProtocol) {
        self.listAPI = listAPI
        self.listStore = ListRealmStore()
    }
    
    func createList(name: String, identifier: String, storeTypeID: Int, completionHandler: @escaping (_ error: String?) -> Void){
        listAPI.createList(name: name, identifier: identifier, storeTypeID: storeTypeID, completionHandler: completionHandler)
    }

    func getList(listID: Int, completionHandler: @escaping ( _ list: ListModel?, _ error: String?) -> Void){
        listAPI.getList(listID: listID, completionHandler: completionHandler)
    }
    
    func getLists(completionHandler: @escaping ( _ lists: [ListModel], _ error: String?) -> Void){
        listAPI.getLists { (lists: [ListModel], error: String?) in
            // Save lists
            for list in lists {
                self.listStore.createList(list: list)
            }
            
            completionHandler(lists, error)
        }
    }

    func updateList(listID: Int, name: String, storeTypeID: Int, completionHandler: @escaping (_ error: String?) -> Void){
        listAPI.updateList(listID: listID, name: name, storeTypeID: storeTypeID, completionHandler: completionHandler)
    }
    
    func restartList(listID: Int, completionHandler: @escaping (String?) -> Void){
        listAPI.restartList(listID: listID, completionHandler: completionHandler)
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

protocol ListRequestProtocol {
    func getList(listID: Int, completionHandler: @escaping ( _ list: ListModel?, _ error: String?) -> Void)
    func getLists(completionHandler: @escaping ( _ lists: [ListModel], _ error: String?) -> Void)
    
    func createList(name: String, identifier: String, storeTypeID: Int, completionHandler: @escaping (_ error: String?) -> Void)
    func updateList(listID: Int, name: String, storeTypeID: Int, completionHandler: @escaping (String?) -> Void)
    func restartList(listID: Int, completionHandler: @escaping (String?) -> Void)
    func deleteList(listID: Int, completionHandler: @escaping (String?) -> Void)
}

protocol ListStoreProtocol {
    func getList(listID: Int) -> ListModel?
    func createList(list: ListModel)
    func deleteList(listID: Int)
}
