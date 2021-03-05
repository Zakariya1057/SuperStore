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
    
    init(listAPI: ListRequestProtocol) {
        self.listAPI = listAPI
    }
    
    func createList(name: String, identifier: String, storeTypeID: Int, completionHandler: @escaping (_ error: String?) -> Void){
        listAPI.createList(name: name, identifier: identifier, storeTypeID: storeTypeID, completionHandler: completionHandler)
    }

    func getList(listID: Int, completionHandler: @escaping ( _ list: ListModel?, _ error: String?) -> Void){
        listAPI.getList(listID: listID, completionHandler: completionHandler)
    }
    
    func getLists(completionHandler: @escaping ( _ lists: [ListModel], _ error: String?) -> Void){
        listAPI.getLists(completionHandler: completionHandler)
    }

    func updateList(listID: Int, name: String, storeTypeID: Int, completionHandler: @escaping (_ error: String?) -> Void){
        listAPI.updateList(listID: listID, name: name, storeTypeID: storeTypeID, completionHandler: completionHandler)
    }
    
    func restartList(listID: Int, completionHandler: @escaping (String?) -> Void){
        listAPI.restartList(listID: listID, completionHandler: completionHandler)
    }
    
    func deleteList(listID: Int, completionHandler: @escaping (String?) -> Void){
        listAPI.deleteList(listID: listID, completionHandler: completionHandler)
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
