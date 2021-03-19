//
//  ListAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 04/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Alamofire

class ListAPI: ListRequestProtocol {
    
    let jsonDecoder = JSONDecoder()
    let requestWorker: RequestProtocol = RequestWorker()

    func getLists(storeTypeID: Int, completionHandler: @escaping ( _ lists: [ListModel], _ error: String?) -> Void){
        let url: String = Config.Route.List.All + "/" + String(storeTypeID)
        
        requestWorker.get(url: url) { (response: () throws -> Data) in
            do {
                let data = try response()
                let listsDataResponse =  try self.jsonDecoder.decode(ListsDataResponse.self, from: data)
                let lists = self.createListModels(listsDataResponse: listsDataResponse)
                completionHandler(lists, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler([], errorMessage)
            } catch {
                print(error)
                completionHandler([], "Failed to get lists. Decoding error, please try again later.")
            }
        }
    }
    
    func getList(listID: Int, completionHandler: @escaping ( _ list: ListModel?, _ error: String?) -> Void){
        let url: String = Config.Route.List.Show + String(listID)
        
        requestWorker.get(url: url) { (response: () throws -> Data) in
            do {
                let data = try response()
                let listDataResponse =  try self.jsonDecoder.decode(ListDataResponse.self, from: data)
                let list = self.createListModel(listDataResponse: listDataResponse)
                completionHandler(list, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(nil, errorMessage)
            } catch {
                print(error)
                completionHandler(nil, "Failed to get lists. Decoding error, please try again later.")
            }
        }
    }
    
    func createList(name: String, identifier: String, storeTypeID: Int, completionHandler: @escaping (_ list: ListModel?, _ error: String?) -> Void){
        let createData:Parameters = ["name": name, "identifier": identifier, "store_type_id": storeTypeID]
        
        requestWorker.post(url:  Config.Route.List.Create, data: createData) { (response: () throws -> Data) in
            do {
                let data = try response()
                let listDataResponse =  try self.jsonDecoder.decode(ListDataResponse.self, from: data)
                let list = self.createListModel(listDataResponse: listDataResponse)
                completionHandler(list, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(nil, errorMessage)
            } catch {
                print(error)
                completionHandler(nil, "Failed to create list. Decoding error, please try again later.")
            }
        }
    }
    
    func updateList(listID: Int, name: String, storeTypeID: Int, completionHandler: @escaping (String?) -> Void) {
        let updateData:Parameters = ["list_id": listID, "name": name, "store_type_id": storeTypeID]
        
        requestWorker.post(url:  Config.Route.List.Update, data: updateData) { (response: () throws -> Data) in
            do {
                _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                print(error)
                completionHandler("Failed to update lists. Decoding error, please try again later.")
            }
        }
    }
    
    func restartList(listID: Int, completionHandler: @escaping (String?) -> Void) {
        requestWorker.post(url:  Config.Route.List.Restart, data: ["list_id": listID]) { (response: () throws -> Data) in
            do {
                _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                print(error)
                completionHandler("Failed to reset list. Decoding error, please try again later.")
            }
        }
    }
    
    func deleteList(listID: Int, completionHandler: @escaping (String?) -> Void) {
        requestWorker.post(url:  Config.Route.List.Delete, data: ["list_id": listID]) { (response: () throws -> Data) in
            do {
                _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                print(error)
                completionHandler("Failed to delete list. Decoding error, please try again later.")
            }
        }
    }
    
}

extension ListAPI {
    func offlineDeletedLists(listIDs: [Int], completionHandler: @escaping (String?) -> Void){
        requestWorker.post(url: Config.Route.List.Offline.Delete, data: ["list_ids": listIDs]) { (response: () throws -> Data) in
            do {
                _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                print(error)
                completionHandler("Failed to delete list. Decoding error, please try again later.")
            }
        }
        
    }
}

extension ListAPI {
    private func createListModels(listsDataResponse: ListsDataResponse) -> [ListModel] {
        let listData = listsDataResponse.data
        return listData.map { (list: ListData) in
            return list.getListModel()
        }
    }
    
    private func createListModel(listDataResponse: ListDataResponse) -> ListModel {
        let listData = listDataResponse.data
        return listData.getListModel()
    }
}
