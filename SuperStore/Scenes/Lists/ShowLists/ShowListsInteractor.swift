//
//  ShowListsInteractor.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 04/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowListsBusinessLogic
{
    func getLists(request: ShowLists.GetLists.Request)
    func deleteList(request: ShowLists.DeleteList.Request)
    func searchList(request: ShowLists.SearchList.Request)
    
    func offlineDeletedList(request: ShowLists.Offline.DeletedLists.Request)
    func offlineEditedList(request: ShowLists.Offline.EditedLists.Request)
    
    var addToList: Bool { get set }
}

protocol ShowListsDataStore
{
    var lists: [ListModel] { get set }
    var addToList: Bool { get set }
    var storeTypeID: Int? { get set }
}

class ShowListsInteractor: ShowListsBusinessLogic, ShowListsDataStore
{
    var presenter: ShowListsPresentationLogic?
    
    var listWorker: ListWorker = ListWorker(listAPI: ListAPI())
    var userSession = UserSessionWorker()
    
    var addToList: Bool = false
    var lists: [ListModel] = []
    
    var storeTypeID: Int? = nil
    
    var offline: Bool {
        return !self.userSession.isOnline()
    }
    
    func getLists(request: ShowLists.GetLists.Request)
    {
        let storeTypeID: Int = self.storeTypeID == nil ? userSession.getStore() : self.storeTypeID!
        
        listWorker.getLists(storeTypeID: storeTypeID) { (lists: [ListModel], error: String?) in
            
            var response = ShowLists.GetLists.Response(lists: lists, error: error)
            
            if error == nil {
                self.lists = lists
            } else {
                response.offline = self.offline
            }
            
            
            self.presenter?.presentLists(response: response)
        }
    }
    
    func deleteList(request: ShowLists.DeleteList.Request)
    {
        let listID = request.listID
        
        lists.removeAll { (list: ListModel) -> Bool in
            return list.id == listID
        }
        
        listWorker.deleteList(listID: listID) { (error: String?) in
            var response = ShowLists.DeleteList.Response(indexPath: request.indexPath, error: error)
            
            if error != nil {
                response.offline = !self.userSession.isOnline()
            }
            
            self.presenter?.presentListDeleted(response: response)
        }
    }
    
    func searchList(request: ShowLists.SearchList.Request){
        let query = request.query
        listWorker.searchLists(storeTypeID: userSession.getStore() ,query: query) { (lists: [ListModel]) in
            let response = ShowLists.GetLists.Response(lists: lists, error: nil)
            self.presenter?.presentLists(response: response)
        }
    }
}

extension ShowListsInteractor {
    func offlineDeletedList(request: ShowLists.Offline.DeletedLists.Request){
        if !offline {
            listWorker.offlineDeletedLists { (error: String?) in
                let response = ShowLists.Offline.DeletedLists.Response(error: error)
                self.presenter?.presentListOfflineDeleted(response: response)
            }
        }
    }
    
    func offlineEditedList(request: ShowLists.Offline.EditedLists.Request){
        if !offline {
            listWorker.offlineEditedLists { (error: String?) in
                let response = ShowLists.Offline.EditedLists.Response(error: error)
                self.presenter?.presentListOfflineEdited(response: response)
            }
        }
    }
}
