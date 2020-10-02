//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol ListItemsDelegate {
    func contentLoaded(list: ListModel)
    func errorHandler(_ message:String)
}

struct ListItemsHandler {
    
    var delegate: ListItemsDelegate?
    
    let requestHandler = RequestHandler()
    
    func request(list_id: Int){
        let host_url = K.Host
        let list_path = K.Request.Lists.List
        let url_string = "\(host_url)/\(list_path)/\(list_id)"
        requestHandler.getRequest(url: url_string, complete: processResults,error:processError)
    }
    
    func update(list_id: Int, list_data:[String: String]){
        let host_url = K.Host
        let list_path = K.Request.Lists.List
        let update_path = K.Request.Lists.ItemUpdate

        let url_string = "\(host_url)/\(list_path)/\(list_id)/\(update_path)"
        requestHandler.postRequest(url: url_string, data: list_data, complete: processResponse, error: processError)
    }

    func delete(list_id: Int, list_data:[String: String]){
        let host_url = K.Host
        let list_path = K.Request.Lists.List
        let delete_path = K.Request.Lists.ItemDelete

        let url_string = "\(host_url)/\(list_path)/\(list_id)/\(delete_path)"
        requestHandler.postRequest(url: url_string, data: list_data, complete: processResponse, error: processError)
    }
    
    func create(list_id: Int, list_data:[String: String]){
        let host_url = K.Host
        let list_path = K.Request.Lists.List
        let create_path = K.Request.Lists.ItemCreate
        
        let url_string = "\(host_url)/\(list_path)/\(list_id)/\(create_path)"
        requestHandler.postRequest(url: url_string, data: list_data, complete: processResponse, error: processError)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            let decoder = JSONDecoder()
            let data = try decoder.decode(ListItemsDataResponse.self, from: data)
            let list_data = data.data
            
            var categories: [ListCategoryModel] = []
            
            for category in list_data.categories ?? [] {
                var items:[ListItemModel] = []
                
                for item in category.items {
                    
                    var discount: DiscountModel? = nil
                    if item.discount != nil {
                        discount = DiscountModel(quantity: item.discount!.quantity, price: item.discount!.price, forQuantity: item.discount!.for_quantity)
                    }
                    
                    items.append(ListItemModel(id: item.id, name: item.name, total_price: item.total_price, price: item.price, product_id: item.product_id, quantity: item.quantity, image: item.large_image ?? "", ticked_off: item.ticked_off, weight: item.weight ?? "",discount: discount))
                }
                
                categories.append(ListCategoryModel(id: category.id, name: category.name, aisle_name: category.aisle_name, items: items))
            }
            
            let list_status:String = list_data.status.lowercased()
            var status: ListStatus = .notStarted
            
            if list_status.contains("completed"){
                status = .completed
            } else if list_status.contains("in progress"){
                status = .inProgress
            } else if list_status.contains("not started"){
                status = .notStarted
            }
            
            let list = ListModel(id: list_data.id, name: list_data.name, created_at: list_data.created_at, status: status, store_id: list_data.store_id, user_id: list_data.user_id, total_price: list_data.total_price, categories: categories)
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded(list: list)
            }

        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func processResponse(_data: Data){
        
    }
    
    func processError(_ message:String){
        self.delegate?.errorHandler(message)
    }
}
