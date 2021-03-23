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
    
    private var listStore: ListStoreProtocol = ListRealmStore()
    private var promotionStore: PromotionRealmStore = PromotionRealmStore()
    
    var userSession = UserSessionWorker()
    
    init(listAPI: ListRequestProtocol) {
        self.listAPI = listAPI
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
        // Unless offline, dont show empty list items
        if let list = listStore.getList(listID: listID), list.categories.count > 0{
            completionHandler(list, nil)
        }
        
        listAPI.getList(listID: listID) { (list: ListModel?, error: String?) in
            
            var listContent = list
            
            if let list = list {
                
                if self.listStore.isEditedList(listID: list.id) {
                    
                    // Add local editted list instead of fetched list
                    if let savedList = self.listStore.getList(listID: list.id) {
                        listContent = savedList
                        
                        self.offlineEditedLists { (error: String?) in }
                    }
                } else {
                    self.listStore.createList(list: listContent!, ignoreCategories: false)
                }
            }
            
            completionHandler(listContent, error)
        }
    }
    
    func getLists(storeTypeID: Int, completionHandler: @escaping ( _ lists: [ListModel], _ error: String?) -> Void){
        let lists = listStore.getLists(storeTypeID: storeTypeID)
        if !userSession.isOnline() || lists.count > 0 {
            completionHandler(lists, nil)
        }
        
        listAPI.getLists(storeTypeID: storeTypeID) { (lists: [ListModel], error: String?) in
            
            var activeLists: [ListModel] = []
            
            for list in lists {
                if !self.listStore.isDeletedList(listID: list.id) {
                    activeLists.append(list)
                    self.listStore.createList(list: list, ignoreCategories: true)
                }
            }
            
            completionHandler(activeLists, error)
        }
    }
    
    func searchLists(storeTypeID: Int, query: String, completionHandler: @escaping ( _ lists: [ListModel]) -> Void){
        let lists = listStore.searchLists(storeTypeID: storeTypeID, query: query)
        completionHandler(lists)
    }
    
    func updateList(listID: Int, name: String, storeTypeID: Int, completionHandler: @escaping (_ error: String?) -> Void){
        listAPI.updateList(listID: listID, name: name, storeTypeID: storeTypeID, completionHandler: completionHandler)
    }
    
    func restartList(listID: Int, completionHandler: @escaping (String?) -> Void){
        
        if !userSession.isOnline() {
            listStore.restartList(listID: listID)
        }
        
        listAPI.restartList(listID: listID) { (error: String?) in
            if error == nil {
                self.listStore.restartList(listID: listID)
            }
            
            completionHandler(error)
        }
    }
    
    func deleteList(listID: Int, completionHandler: @escaping (String?) -> Void){
        
        if !userSession.isOnline() {
            listStore.deleteList(listID: listID, offline: true)
        }
        
        listAPI.deleteList(listID: listID) { (error: String?) in
            if error == nil {
                self.listStore.deleteList(listID: listID, offline: false)
            }
            
            completionHandler(error)
        }
    }
}

extension ListWorker {
    func offlineDeletedLists(completionHandler: @escaping (String?) -> Void){
        let lists = listStore.getDeletedLists()
        
        let listIDs = lists.map{ $0.id }
        
        if listIDs.count > 0 {
            
            listAPI.offlineDeletedLists(listIDs: listIDs) { (error: String?) in
                if error == nil {
                    for listID in listIDs {
                        self.listStore.deleteList(listID: listID, offline: false)
                    }
                }
                completionHandler(error)
            }
        }
    }
    
    func offlineEditedLists(completionHandler: @escaping (String?) -> Void){
        let lists = listStore.getEditedLists()
        
        if lists.count > 0 {
            
            listAPI.offlineEditedLists(lists: lists) { (error: String?) in
                
                if error == nil {
                    for list in lists {
                        self.listStore.syncList(listID: list.id)
                    }
                }
                
                completionHandler(error)
                
            }
        }
    }
}

extension ListWorker {
    func updateListTotalPrice(listID: Int){
        listStore.updateListTotalPrice(listID: listID)
    }
}

protocol ListRequestProtocol {
    func getList(listID: Int, completionHandler: @escaping ( _ list: ListModel?, _ error: String?) -> Void)
    func getLists(storeTypeID: Int, completionHandler: @escaping ( _ lists: [ListModel], _ error: String?) -> Void)
    
    func createList(name: String, identifier: String, storeTypeID: Int, completionHandler: @escaping (_ list: ListModel?, _ error: String?) -> Void)
    func updateList(listID: Int, name: String, storeTypeID: Int, completionHandler: @escaping (String?) -> Void)
    func restartList(listID: Int, completionHandler: @escaping (String?) -> Void)
    func deleteList(listID: Int, completionHandler: @escaping (String?) -> Void)
    
    func offlineDeletedLists(listIDs: [Int], completionHandler: @escaping (String?) -> Void)
    func offlineEditedLists(lists: [ListModel], completionHandler: @escaping (String?) -> Void)
}

protocol ListStoreProtocol {
    func getList(listID: Int) -> ListModel?
    func getLists(storeTypeID: Int) -> [ListModel]
    func createList(list: ListModel, ignoreCategories: Bool)
    func deleteList(listID: Int, offline: Bool)
    
    func searchLists(storeTypeID: Int, query: String) -> [ListModel]
    
    func updateListTotalPrice(listID: Int)
    func restartList(listID: Int)
    
    func createListObject(list: ListModel, ignoreCategories: Bool) -> ListObject
    
    
    func listEdited(listID: Int)
    
    func getDeletedLists() -> [ListModel]
    func getEditedLists() -> [ListModel]
    
    func isEditedList(listID: Int) -> Bool
    func isDeletedList(listID: Int) -> Bool
    
    func syncList(listID: Int)
}
