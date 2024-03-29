//
//  ListItemAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 05/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Alamofire

class ListItemAPI: API, ListItemRequestProtocol {

    func updateItem(listID: Int, productID: Int, quanity: Int, tickedOff: Bool, completionHandler: @escaping ( _ error: String?) -> Void){
        let url: String = Config.Routes.List.ListRoute + "/" + String(listID) + Config.Routes.List.Item.Update
        
        let itemData: Parameters = [
            "product_id": productID,
            "quantity": quanity,
            "ticked_off": tickedOff
        ]
        
        requestWorker.post(url: url, data: itemData) { (response: () throws -> Data) in
            do {
                _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                print(error)
                completionHandler("Failed to update list item. Decoding error, please try again later.")
            }
        }
    }
    
    func deleteItem(listID: Int, productID: Int, completionHandler: @escaping (String?) -> Void) {
        let url: String = Config.Routes.List.ListRoute + "/" + String(listID) + Config.Routes.List.Item.Delete
        
        requestWorker.post(url: url, data: ["product_id": productID]) { (response: () throws -> Data) in
            do {
                _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                print(error)
                completionHandler("Failed to update list item. Decoding error, please try again later.")
            }
        }
    }
    
    func createItem(listID: Int, productID: Int, parentCategoryID: Int, completionHandler: @escaping (ListItemModel?, String?) -> Void) {
        let url: String = Config.Routes.List.ListRoute + "/" + String(listID) + Config.Routes.List.Item.Create
        
        let itemData: Parameters = [
            "list_id": listID,
            "product_id": productID,
            "parent_category_id": parentCategoryID
        ]
        
        requestWorker.post(url: url, data: itemData) { (response: () throws -> Data) in
            do {
                let data = try response()
                let listItemDataResponse =  try self.jsonDecoder.decode(ListItemDataResponse.self, from: data)
                let list = self.createListItemModel(listItemDataResponse: listItemDataResponse)
                completionHandler(list, nil)
                
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(nil, errorMessage)
            } catch {
                print(error)
                completionHandler(nil, "Failed to update list item. Decoding error, please try again later.")
            }
        }
    }
}

extension ListItemAPI {
    private func createListItemModel(listItemDataResponse: ListItemDataResponse) -> ListItemModel {
        return listItemDataResponse.data.getListItemModel()
    }
}
