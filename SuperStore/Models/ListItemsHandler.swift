////
////  DataHandler.swift
////  ZPlayer
////
////  Created by Zakariya Mohummed on 25/05/2020.
////  Copyright © 2020 Zakariya Mohummed. All rights reserved.
////
//
//import Foundation
//
//protocol ListItemsDelegate {
//    func contentLoaded(list: ListModel)
//    func errorHandler(_ message:String)
//    func logOutUser()
//}
//
//struct ListItemsHandler {
//    
//    var delegate: ListItemsDelegate?
//    
//    let requestHandler = RequestHandler()
//    
//    func request(listID: Int){
//        let urlString = "\(K.Host)/\(K.Request.Lists.List)/\(listID)"
//        requestHandler.getRequest(url: urlString, complete: processResults,error:processError,logOutUser: logOutUser)
//    }
//    
//    func update(listID: Int, listData:[String: String]){
//        let urlString = "\(K.Host)/\(K.Request.Lists.List)/\(listID)/\(K.Request.Lists.ItemUpdate)"
//        requestHandler.postRequest(url: urlString, data: listData, complete: processResponse, error: processError,logOutUser: logOutUser)
//    }
//
//    func delete(listID: Int, listData:[String: String]){
//        let listPath = K.Request.Lists.List
//        let deletePath = K.Request.Lists.ItemDelete
//
//        let urlString = "\(K.Host)/\(listPath)/\(listID)/\(deletePath)"
//        requestHandler.postRequest(url: urlString, data: listData, complete: processResponse, error: processError,logOutUser: logOutUser)
//    }
//    
//    func create(listID: Int, listData:[String: String]){
//        let listPath = K.Request.Lists.List
//        let createPath = K.Request.Lists.ItemCreate
//        
//        let urlString = "\(K.Host)/\(listPath)/\(listID)/\(createPath)"
//        requestHandler.postRequest(url: urlString, data: listData, complete: processResponse, error: processError,logOutUser: logOutUser)
//    }
//    
//    func processResults(_ data:Data){
//        
//        do {
//            
//            let decoder = JSONDecoder()
//            let data = try decoder.decode(ListItemsDataResponse.self, from: data)
//            let list_data = data.data
//            
//            var categories: [ListCategoryModel] = []
//            
//            for category in list_data.categories ?? [] {
//                var items:[ListItemModel] = []
//                
//                for item in category.items {
//                    
//                    var promotion: PromotionModel? = nil
//                    if item.promotion != nil {
//                        promotion = PromotionModel(id: item.promotion!.id, name: item.promotion!.name, quantity: item.promotion!.quantity, price: item.promotion!.price, forQuantity: item.promotion!.for_quantity)
//                    }
//                    
//                    items.append(ListItemModel(id: item.id, name: item.name, image: item.large_image!, quantity: item.quantity, productID: item.product_id, price: item.price, weight: item.weight, promotion: promotion, listID: list_data.id, tickedOff: item.ticked_off))
//                }
//                
//                categories.append(ListCategoryModel(id: category.id, name: category.name, aisleName: category.aisle_name, items: items, listID: list_data.id))
//            }
//            
//            let list_status:String = list_data.status.lowercased()
//            var status: ListStatus = .notStarted
//            
//            if list_status.contains("completed"){
//                status = .completed
//            } else if list_status.contains("in progress"){
//                status = .inProgress
//            } else if list_status.contains("not started"){
//                status = .notStarted
//            }
//            
//            let date_format: DateFormatter = DateFormatter()
//            date_format.dateFormat = "dd MMMM Y"
//
//            let created_date: Date = date_format.date(from: list_data.created_at)!
//            
//            let list = ListModel(id: list_data.id, name: list_data.name, createdAt: created_date, status: status, identifier: list_data.identifier, storeID: list_data.store_id, userID: list_data.user_id, totalPrice: list_data.total_price, oldTotalPrice: list_data.old_total_price, categories: categories,totalItems: list_data.total_items, tickedOffItems: list_data.ticked_off_items)
//            
//            DispatchQueue.main.async {
//                self.delegate?.contentLoaded(list: list)
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
//    func processResponse(_data: Data){
//        
//    }
//    
//    func processError(_ message:String){
//        print(message)
//        self.delegate?.errorHandler(message)
//    }
//}
