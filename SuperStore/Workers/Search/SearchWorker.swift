//
//  SearchWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class SearchWorker {
    var searchAPI: SearchRequestProtocol
    var searchSuggestionStore: SuggestionStoreProtocol
    var searchResultsStore: ProductResultsStoreProtocol
    
    init(searchAPI: SearchRequestProtocol) {
        self.searchAPI = searchAPI
        
        self.searchSuggestionStore = SuggestionRealmStore()
        self.searchResultsStore = ProductResultsRealmStore()
    }
    
    func getSuggestions(storeTypeID: Int, query: String, completionHandler: @escaping ( _ suggestions: [SuggestionModel], _ error: String?) -> Void){
        let savedSuggestions = searchSuggestionStore.searchSuggestion(storeTypeID: storeTypeID, query: query)
        if savedSuggestions.count > 0 {
            completionHandler(savedSuggestions, nil)
        }
        
        searchAPI.getSuggestions(storeTypeID: storeTypeID, query: query) { (suggestions: [SuggestionModel], error: String?) in
            if error == nil {
                self.searchSuggestionStore.createSuggestions(suggestions: suggestions, storeTypeID: storeTypeID)
            }

            completionHandler(suggestions, error)
        }
    }
    
    func getProductResults(query: ProductQueryModel, page: Int, completionHandler: @escaping (_ ResultsModel: ProductResultsModel?, _ error: String?) -> Void){
        
        if page == 1 {
            let results = searchResultsStore.searchResults(query: query)
            if results.products.count > 0 {
                completionHandler(results, nil)
            }
        }

        searchAPI.getProductResults(data: query, page: page) { (results: ProductResultsModel?, error: String?) in
            if let results = results {
                self.searchResultsStore.createResults(results: results)
            }
            
            completionHandler(results, error)
        }
    }
    
    func getRecentSuggestions(storeTypeID: Int, limit: Int, completionHandler: @escaping (_ suggestions: [SuggestionModel], _ error: String?) -> Void){
        let savedSuggestion = searchSuggestionStore.getRecentSuggestions(storeTypeID: storeTypeID, limit: limit)
        completionHandler(savedSuggestion, nil)
    }

    func suggestionSelected(suggestion: SuggestionModel){
        searchSuggestionStore.suggestionSelected(suggestion: suggestion)
    }
    
}

protocol SearchRequestProtocol {
    func getSuggestions(storeTypeID: Int, query: String, completionHandler: @escaping ( _ suggestions: [SuggestionModel], _ error: String?) -> Void)
    func getProductResults(data: ProductQueryModel, page: Int, completionHandler: @escaping ( _ ResultsModel: ProductResultsModel?, _ error: String?) -> Void)
}

protocol SuggestionStoreProtocol {
    func createSuggestions(suggestions: [SuggestionModel], storeTypeID: Int)
    func createSuggestion(suggestion: SuggestionModel, storeTypeID: Int)
    
    func searchSuggestion(storeTypeID: Int, query: String) -> [SuggestionModel]
    func getRecentSuggestions(storeTypeID: Int, limit count: Int) -> [SuggestionModel]
    
    func suggestionSelected(suggestion: SuggestionModel)
}

protocol ProductResultsStoreProtocol {
    func createResults(results: ProductResultsModel)
    func searchResults(query: ProductQueryModel) -> ProductResultsModel
}
