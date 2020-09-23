//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol SearchSuggestionsDelegate {
    func contentLoaded(suggestions: [SearchModel])
//    func errorHandler(_ message:String)
}

protocol SearchResultsDelegate {
    func contentLoaded(stores: [StoreModel], products: [ProductModel])
//    func errorHandler(_ message:String)
}

struct SearchHandler {
    
    var suggestionsDelegate: SearchSuggestionsDelegate?
    var resultsDelegate: SearchResultsDelegate?
    
    let requestHandler = RequestHandler()
    
    func requestSuggestions(query: String){
        let hostURL = K.Host
        let suggestionsPath = K.Request.Search.Suggestions
        let urlString = "\(hostURL)/\(suggestionsPath)/\(query)"
        requestHandler.getRequest(url: urlString, complete: processSuggestionsResults,error:processError)
    }
    
    func requestResults(searchData: [String: String]){
        let hostURL = K.Host
        let resultsPath = K.Request.Search.Results
        let urlString = "\(hostURL)/\(resultsPath)"
        requestHandler.postRequest(url: urlString, data: searchData, complete: processResults, error: processError)
    }
    
    func processSuggestionsResults(_ data:Data){
        
        do {
            
            print("Processing Results")
            
            let decoder = JSONDecoder()
            let decodedSuggestionsData = try decoder.decode(SearchSuggestionsDataResponse.self, from: data)
            let suggestionsTypes = decodedSuggestionsData.data
            
            var suggestions: [SearchModel] = []
            
            for store in suggestionsTypes.stores {
                suggestions.append(SearchModel(id: store.id, name: store.name, type: .store))
            }
            
            for childCategory in suggestionsTypes.child_categories {
                suggestions.append(SearchModel(id: childCategory.id, name: childCategory.name, type: .childCategory))
            }
            
            for parentCategory in suggestionsTypes.parent_categories {
                suggestions.append(SearchModel(id: parentCategory.id, name: parentCategory.name, type: .parentCategory))
            }
            
            for product in suggestionsTypes.products {
                suggestions.append(SearchModel(id: product.id, name: product.name, type: .product))
            }
            
            DispatchQueue.main.async {
                self.suggestionsDelegate?.contentLoaded(suggestions: suggestions)
            }
        
        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func processResults(_ data:Data){
        
        do {
            
            print("Processing Results")
            
            let decoder = JSONDecoder()
            let decodedResultsData = try decoder.decode(SearchResultsDataResponse.self, from: data)
            let resultsData = decodedResultsData.data
            
            var stores: [StoreModel] = []
            var products: [ProductModel] = []

            for store in resultsData.stores {
                stores.append( StoreModel(id: store.id, name: store.name, logo: store.small_logo, opening_hours: [], location: LocationModel(city: store.location.city, address_line1: store.location.address_line1, address_line2: store.location.address_line2, address_line3: store.location.address_line3, postcode: store.location.postcode), facilities: []))
            }
            
            for product_item in resultsData.products {
                products.append( ProductModel(id: product_item.id, name: product_item.name, image: product_item.small_image, description: product_item.description, quantity: 0, weight: product_item.weight,parent_category_id: product_item.parent_category_id!,parent_category_name: product_item.parent_category_name!, price: product_item.price, location: "", avg_rating: product_item.avg_rating, total_reviews_count: product_item.total_reviews_count))
            }
            
            DispatchQueue.main.async {
                self.resultsDelegate?.contentLoaded(stores: stores, products: products)
            }
        
        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func processError(_ message:String){
//        self.delegate?.errorHandler(message)
    }
}
