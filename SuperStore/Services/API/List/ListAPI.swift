//
//  ListAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 04/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Alamofire

class ListAPI: API, ListRequestProtocol {
    
    func getLists(supermarketChainID: Int, completionHandler: @escaping ( _ lists: [ListModel], _ error: String?) -> Void){
        let url: String = Config.Routes.List.All + "/" + String(supermarketChainID)
        
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
        let url: String = Config.Routes.List.Show + String(listID)
        
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
    
    func createList(name: String, identifier: String, supermarketChainID: Int, completionHandler: @escaping (_ list: ListModel?, _ error: String?) -> Void){
        let createData:Parameters = ["name": name, "identifier": identifier, "supermarket_chain_id": supermarketChainID]
        
        requestWorker.post(url:  Config.Routes.List.Create, data: createData) { (response: () throws -> Data) in
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
    
    func updateList(listID: Int, name: String, supermarketChainID: Int, completionHandler: @escaping (String?) -> Void) {
        let updateData:Parameters = ["list_id": listID, "name": name, "supermarket_chain_id": supermarketChainID]
        
        requestWorker.post(url:  Config.Routes.List.Update, data: updateData) { (response: () throws -> Data) in
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
        requestWorker.post(url:  Config.Routes.List.Restart, data: ["list_id": listID]) { (response: () throws -> Data) in
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
        requestWorker.post(url:  Config.Routes.List.Delete, data: ["list_id": listID]) { (response: () throws -> Data) in
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
        requestWorker.post(url: Config.Routes.List.Offline.Delete, data: ["list_ids": listIDs]) { (response: () throws -> Data) in
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
    
    func offlineEditedLists(lists: [ListModel], completionHandler: @escaping (String?) -> Void){

        let listsData = createListData(lists: lists)
        
        requestWorker.post(url: Config.Routes.List.Offline.Edited, data: ["lists": listsData]) { (response: () throws -> Data) in
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


extension ListAPI {
    private func createListData(lists: [ListModel]) -> [Parameters] {
        
        var listsData: [Parameters] = []

        for list in lists {

            let listData: Parameters = [
                "id": list.id,
                "categories": createListCategoriesData(categories: list.categories)
            ]
            
            listsData.append(listData)

        }
        
        return listsData
        
    }
    
    private func createListCategoriesData(categories: [ListCategoryModel]) -> [Parameters]{
        
        var categoriesData: [Parameters] = []
        
        for category in categories {
            
            let categoryData: Parameters = [
                "id": category.id,
                "items": createListItemsData(items: category.items)
            ]
            
            categoriesData.append(categoryData)
            
        }
        
        return categoriesData
    }
    
    private func createListItemsData(items: [ListItemModel]) -> [Parameters]{
        var itemsData: [Parameters] = []
        
        for item in items {
            let itemData: Parameters = [
                "product_id": item.productID,
                "quantity": item.quantity,
                "ticked_off": item.tickedOff
            ]
            
            itemsData.append(itemData)
        }
        
        return itemsData
    }
}
