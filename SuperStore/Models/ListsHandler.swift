//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol ListDelegate {
    func contentLoaded(lists: [ListModel])
    func errorHandler(_ message:String)
}

struct ListsHandler {
    
    var delegate: ListDelegate?
    
    let requestHandler = RequestHandler()
    
    var listPath = K.Request.Lists.List
    
    func request(){
        let url_string = "\(K.Host)/\(listPath)/"
        requestHandler.getRequest(url: url_string, complete: processResults,error:processError)
    }
    
    func insert(list_data:[String: String]){
        let listInsert = K.Request.Lists.ListCreate
        let url_string = "\(K.Host)/\(listPath)/\(listInsert)"
        requestHandler.postRequest(url: url_string, data: list_data, complete: processResults, error: processError)
    }
    
    func update(list_data: [String: String]){
        let listUpdate = K.Request.Lists.ListUpdate
        let url_string = "\(K.Host)/\(listPath)/\(listUpdate)"
        requestHandler.postRequest(url: url_string, data: list_data, complete:  { _ in } , error: processError)
    }
    
    func delete(list_data: [String: String]){
        let listDelete = K.Request.Lists.ListDelete
        let url_string = "\(K.Host)/\(listPath)/\(listDelete)"
        requestHandler.postRequest(url: url_string, data: list_data, complete: { _ in } , error: processError)
    }
    
    // Restarting Shoppping List, Setting All To Unchecked
    func restart(list_id: Int){
        let restartPath = K.Request.Lists.ListRestart
        let url_string = "\(K.Host)/\(listPath)/\(list_id)/\(restartPath)"
        requestHandler.postRequest(url: url_string, data: ["list_id": String(list_id)], complete: { _ in }, error: processError)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            let decoder = JSONDecoder()
            let data = try decoder.decode(ListsDataResponse.self, from: data)
            let lists_data = data.data
            
            var lists:[ListModel] = []
            
            for list in lists_data {
                
                let list_status:String = list.status.lowercased()
                var status: ListStatus = .notStarted
                
                if list_status.contains("completed"){
                    status = .completed
                } else if list_status.contains("in progress"){
                    status = .inProgress
                } else if list_status.contains("not started"){
                    status = .notStarted
                }
                
                lists.append( ListModel(id: list.id, name: list.name, created_at: list.created_at, status: status, store_id: list.store_id, user_id: list.user_id, total_price: list.total_price, old_total_price: list.old_total_price, categories: []))
            }
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded(lists: lists)
            }

        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func processError(_ message:String){
        self.delegate?.errorHandler(message)
    }
}
