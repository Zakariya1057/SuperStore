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
            
            print("Home Data Loaded")
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(HomeResponseData.self, from: data)
            let data = decodedData.data
            
            var lists: [ListProgressModel] = []
            var stores: [StoreModel] = []
            var promotions: [DiscountModel] = []
            
            var featured: [ProductModel] = []
            var groceries: [ProductModel] = []
            var monitoring: [ProductModel] = []
            
            var categories: [String: [ProductModel]] = [:]
            
            for list in data.lists {
                lists.append(ListProgressModel(id: list.id, name: list.name, totalItems: list.total_items, tickedOffItems: list.ticked_off_items))
            }
            
            for store in data.stores {
                let storeLocation = store.location
                let location = LocationModel(city: storeLocation.city, address_line1: storeLocation.address_line1, address_line2: storeLocation.address_line2, address_line3: storeLocation.address_line3, postcode: storeLocation.postcode, latitude: storeLocation.latitude, longitude: storeLocation.longitude)
                
                stores.append(StoreModel(id: store.id, name: store.name, logo: store.small_logo, opening_hours: [], location: location, facilities: []))
            }
            
            for promotion in data.promotions {
                promotions.append(DiscountModel(id: promotion.id, name: promotion.name, quantity: promotion.quantity, price: promotion.price, forQuantity: promotion.for_quantity))
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
            newList.append(ProductModel(id: product.id, name: product.name, image: product.small_image, description: product.description, quantity: 1, weight: product.weight, parent_category_id: nil, parent_category_name: nil, price: product.price, location: nil, avg_rating: product.avg_rating, total_reviews_count: product.total_reviews_count, discount: nil))
        }
        
        return newList
    }
    
    func processError(_ message:String){
        self.delegate?.errorHandler(message)
    }
}
