//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol HomeRequestDelegate {
    func contentLoaded(content: HomeModel)
    func errorHandler(_ message:String)
    func logOutUser()
}

struct HomeHandler {
    
    var delegate: HomeRequestDelegate?
    
    let requestHandler = RequestHandler()
    
    func request(){
        requestHandler.getRequest(url: "\(K.Host)/\(K.Request.Home)", complete: processResults,error:processError,logOutUser: logOutUser)
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
            
            let dateFormat: DateFormatter = DateFormatter()
            dateFormat.dateFormat = "dd MMMM Y"

            for list in data.lists ?? [] {
                
                var status: ListStatus = .completed
                
                if list.status.lowercased().contains("in progress"){
                    status = .inProgress
                } else if list.status.lowercased().contains("not started"){
                    status = .notStarted
                }
                
                let createdDate: Date = dateFormat.date(from: list.created_at)!
                
                lists.append(
                    ListModel(id: list.id, name: list.name, createdAt: createdDate, status: status, identifier: list.identifier, storeID: list.store_id, userID: list.user_id, totalPrice: list.total_price, oldTotalPrice: list.old_total_price, categories: [], totalItems: list.total_items, tickedOffItems: list.ticked_off_items)
                )
            }
            
            for store in data.stores ?? []{
                let storeLocation = store.location
                let location = LocationModel(storeID: store.id, city: storeLocation.city, addressLine1: storeLocation.address_line1, addressLine2: storeLocation.address_line2, addressLine3: storeLocation.address_line3, postcode: storeLocation.postcode, latitude: storeLocation.latitude, longitude: storeLocation.longitude)
                
                stores.append(StoreModel(id: store.id, name: store.name, logo: store.small_logo, openingHours: [], location: location, facilities: [], storeTypeID: store.store_type_id))
            }
            
            for promotion in data.promotions ?? []{
                promotions.append(PromotionModel(id: promotion.id, name: promotion.name, quantity: promotion.quantity!, price: promotion.price, forQuantity: promotion.for_quantity))
            }
            
            featured = addProductsToList(products: data.featured ?? [])
            groceries = addProductsToList(products: data.groceries ?? [])
            monitoring = addProductsToList(products: data.monitoring ?? [])
            
            for category in data.categories ?? [:] {
                let name:String = category.key
                let products:[ProductData] = category.value
                
                categories[name] = addProductsToList(products: products)
        
            }
            
            let content = HomeModel(lists: lists, stores: stores, featured: featured, groceries: groceries, monitoring: monitoring, promotions: promotions, categories: categories)
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded(content: content)
            }
            
        } catch {
            processError("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func addProductsToList(products: [ProductData]) -> [ProductModel]{
        
        var newList:[ProductModel] = []
        
        for product in products {
            newList.append(
                ProductModel(id: product.id, name: product.name, smallImage: product.small_image, largeImage: product.large_image, description: product.description, quantity: 0, price: product.price, avgRating: product.avg_rating, totalReviewsCount: product.total_reviews_count, promotion: nil, storage: product.storage, weight: product.weight, parentCategoryId: product.parent_category_id, parentCategoryName: product.parent_category_name, childCategoryName: nil, dietaryInfo: product.dietary_info, allergenInfo: product.allergen_info, brand: product.brand, reviews: [], favourite: nil, monitoring: nil, ingredients: [], recommended: []))
        }
        
        return newList
    }
    
    func logOutUser(){
        self.delegate?.logOutUser()
    }
    
    func processError(_ message:String){
        print(message)
        self.delegate?.errorHandler(message)
    }
}
