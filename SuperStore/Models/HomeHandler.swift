//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol HomeDelegate {
    func contentLoaded(content: HomeModel)
    func errorHandler(_ message:String)
}

struct HomeHandler {
    
    var delegate: HomeDelegate?
    
    let requestHandler = RequestHandler()
    
    func request(){
        let homePath = K.Request.Home
        let url = "\(K.Host)/\(homePath)"
        requestHandler.getRequest(url: url, complete: processResults,error:processError)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(HomeResponseData.self, from: data)
            let data = decodedData.data
            
            var lists: [ListModel] = []
            var stores: [StoreModel] = []
            var promotions: [PromotionModel] = []
            
            var featured: [ProductModel] = []
            var groceries: [ProductModel] = []
            var monitoring: [ProductModel] = []
            
            var categories: [String: [ProductModel]] = [:]
            
            let date_format: DateFormatter = DateFormatter()
            date_format.dateFormat = "dd MMMM Y"

            for list in data.lists {
                
                var status: ListStatus = .completed
                
                if list.status.lowercased().contains("in progress"){
                    status = .inProgress
                } else if list.status.lowercased().contains("not started"){
                    status = .notStarted
                }
                
                let created_date: Date = date_format.date(from: list.created_at)!
                
                lists.append(
                    ListModel(id: list.id, name: list.name, created_at: created_date, status: status, identifier: list.identifier, store_id: list.store_id, user_id: list.user_id, totalPrice: list.total_price, old_total_price: list.old_total_price, categories: [], totalItems: list.total_items, tickedOffItems: list.ticked_off_items)
                )
            }
            
            for store in data.stores {
                let storeLocation = store.location
                let location = LocationModel(store_id: store.id, city: storeLocation.city, address_line1: storeLocation.address_line1, address_line2: storeLocation.address_line2, address_line3: storeLocation.address_line3, postcode: storeLocation.postcode, latitude: storeLocation.latitude, longitude: storeLocation.longitude)
                
                stores.append(StoreModel(id: store.id, name: store.name, logo: store.small_logo, opening_hours: [], location: location, facilities: [], store_type_id: store.store_type_id))
            }
            
            for promotion in data.promotions {
                promotions.append(PromotionModel(id: promotion.id, name: promotion.name, quantity: promotion.quantity!, price: promotion.price, forQuantity: promotion.for_quantity))
            }
            
            featured = addProductsToList(products: data.featured)
            groceries = addProductsToList(products: data.groceries)
            monitoring = addProductsToList(products: data.monitoring)
            
            for category in data.categories {
                let name:String = category.key
                let products:[ProductData] = category.value
                
                categories[name] = addProductsToList(products: products)
        
            }
            
            let content = HomeModel(lists: lists, stores: stores, featured: featured, groceries: groceries, monitoring: monitoring, promotions: promotions, categories: categories)
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded(content: content)
            }

            
        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func addProductsToList(products: [ProductData]) -> [ProductModel]{
        
        var newList:[ProductModel] = []
        
        for product in products {
            newList.append(ProductModel(id: product.id, name: product.name, image: product.small_image, quantity: 0, product_id: product.id, price: product.price, weight: product.weight, promotion: nil, description: product.description, favourite: product.favourite, avg_rating: product.avg_rating, total_reviews_count: product.total_reviews_count, parent_category_id: product.parent_category_id, parent_category_name: product.parent_category_name))
        }
        
        return newList
    }
    
//    func processError(_ message:String, unauthenticated: Bool = false){
    func processError(_ message:String){
        self.delegate?.errorHandler(message)
    }
}
