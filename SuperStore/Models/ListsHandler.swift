////
////  DataHandler.swift
////  ZPlayer
////
////  Created by Zakariya Mohummed on 25/05/2020.
////  Copyright © 2020 Zakariya Mohummed. All rights reserved.
////
//
//import Foundation
//import Alamofire
//
//protocol ListDelegate {
//    func contentLoaded(lists: [ListModel])
//    func errorHandler(_ message:String)
//    func logOutUser()
//}
//
//struct ListsHandler {
//    
//    var delegate: ListDelegate?
//    
//    let requestHandler = RequestHandler()
//    
//    var listPath = K.Request.Lists.List
//    
//    func request(){
//        let urlString = "\(K.Host)/\(listPath)/"
//        requestHandler.getRequest(url: urlString, complete: processResults,error:processError, logOutUser: logOutUser)
//    }
//    
//    func insert(list_data: Parameters){
//        let listInsert = K.Request.Lists.ListCreate
//        let urlString = "\(K.Host)/\(listPath)/\(listInsert)"
//        requestHandler.postRequest(url: urlString, data: list_data, complete: processResults, error: processError, logOutUser: logOutUser)
//    }
//    
//    func update(list_data: Parameters){
//        let listUpdate = K.Request.Lists.ListUpdate
//        let urlString = "\(K.Host)/\(listPath)/\(listUpdate)"
//        requestHandler.postRequest(url: urlString, data: list_data, complete: { _ in self.delegate?.contentLoaded(lists: [] ) }, error: processError, logOutUser: logOutUser)
//    }
//    
//    func delete(list_data: [String: String]){
//        let listDelete = K.Request.Lists.ListDelete
//        let urlString = "\(K.Host)/\(listPath)/\(listDelete)"
//        requestHandler.postRequest(url: urlString, data: list_data, complete: { _ in } , error: processError, logOutUser: logOutUser)
//    }
//    
//    // Restarting Shoppping List, Setting All To Unchecked
//    func restart(listID: Int){
//        let restartPath = K.Request.Lists.ListRestart
//        let urlString = "\(K.Host)/\(listPath)/\(listID)/\(restartPath)"
//        requestHandler.postRequest(url: urlString, data: ["identifier": String(listID)], complete: { _ in self.delegate?.contentLoaded(lists: [] )}, error: processError, logOutUser: logOutUser)
//    }
//    
//    func processResults(_ data:Data){
//        
//        do {
//            
//            let decoder = JSONDecoder()
//            let data = try decoder.decode(ListsDataResponse.self, from: data)
//            let lists_data = data.data
//            
//            var lists:[ListModel] = []
//            
//            for list in lists_data {
//                
//                let list_status:String = list.status.lowercased()
//                var status: ListStatus = .notStarted
//                
//                if list_status.conftains("completed"){
//                    status = .completed
//                } else if list_status.contains("in progress"){
//                    status = .inProgress
//                } else if list_status.contains("not started"){
//                    status = .notStarted
//                }
//                
//                let date_format: DateFormatter = DateFormatter()
//                date_format.dateFormat = "dd MMMM Y"
//
//                let created_date: Date = date_format.date(from: list.created_at)!
//                
//                lists.append( ListModel(id: list.id, name: list.name, createdAt: created_date, status: status, identifier: list.identifier, storeID: list.store_id, userID: list.user_id, totalPrice: list.total_price, oldTotalPrice: list.old_total_price, categories: [], totalItems: list.total_items, tickedOffItems: list.ticked_off_items))
//            }
//            
//            DispatchQueue.main.async {
//                self.delegate?.contentLoaded(lists: lists)
//            }
//
//        } catch {
//            processError("Decoding Data Error: \(error)")
//        }
//        
//        
//    }
//    
//    func logOutUser(){
//        self.delegate?.logOutUser()
//    }
//    
//    func processError(_ message:String){
//        print(message)
//        self.delegate?.errorHandler(message)
//    }
//}
