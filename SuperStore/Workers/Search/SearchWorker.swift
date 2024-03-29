//
//  SearchWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class SearchWorker {
    private var searchAPI: SearchRequestProtocol
    private var searchSuggestionStore: SuggestionStoreProtocol
    private var searchResultsStore: ProductResultsStoreProtocol
    
    init(searchAPI: SearchRequestProtocol) {
        self.searchAPI = searchAPI
        
        self.searchSuggestionStore = SuggestionRealmStore()
        self.searchResultsStore = ProductResultsRealmStore()
    }
    
    func getSuggestions(supermarketChainID: Int, query: String, offline: Bool, completionHandler: @escaping ( _ suggestions: [SuggestionModel], _ error: String?) -> Void){
        
        if offline {
            let savedSuggestions = searchSuggestionStore.searchSuggestion(supermarketChainID: supermarketChainID, query: query)
            if savedSuggestions.count > 0 {
                completionHandler(savedSuggestions, nil)
            }
        }

        searchAPI.getSuggestions(supermarketChainID: supermarketChainID, query: query) { (suggestions: [SuggestionModel], error: String?) in
            if error == nil {
                self.searchSuggestionStore.createSuggestions(suggestions: suggestions, supermarketChainID: supermarketChainID)
            }

            completionHandler(suggestions, error)
        }
    }
    
    func getProductResults(query: SearchQueryRequest, page: Int, completionHandler: @escaping (_ ResultsModel: ProductResultsModel?, _ error: String?) -> Void){
        
        if page == 1 && !query.refineSort {
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
    
    func getRecentSuggestions(supermarketChainID: Int, limit: Int, completionHandler: @escaping (_ suggestions: [SuggestionModel], _ error: String?) -> Void){
        let savedSuggestion = searchSuggestionStore.getRecentSuggestions(supermarketChainID: supermarketChainID, limit: limit)
        completionHandler(savedSuggestion, nil)
    }

    func suggestionSelected(suggestion: SuggestionModel){
        searchSuggestionStore.suggestionSelected(suggestion: suggestion)
    }
    
}

extension SearchWorker {
    func clearSearchCache(){
        searchSuggestionStore.clearSearchCache()
    }
}

protocol SearchRequestProtocol {
    func getSuggestions(supermarketChainID: Int, query: String, completionHandler: @escaping ( _ suggestions: [SuggestionModel], _ error: String?) -> Void)
    func getProductResults(data: SearchQueryRequest, page: Int, completionHandler: @escaping ( _ ResultsModel: ProductResultsModel?, _ error: String?) -> Void)
}

protocol SuggestionStoreProtocol {
    func createSuggestions(suggestions: [SuggestionModel], supermarketChainID: Int)
    func createSuggestion(suggestion: SuggestionModel, supermarketChainID: Int)
    
    func searchSuggestion(supermarketChainID: Int, query: String) -> [SuggestionModel]
    func getRecentSuggestions(supermarketChainID: Int, limit count: Int) -> [SuggestionModel]
    
    func suggestionSelected(suggestion: SuggestionModel)
    
    func clearSearchCache()
}

protocol ProductResultsStoreProtocol {
    func createResults(results: ProductResultsModel)
    func searchResults(query: SearchQueryRequest) -> ProductResultsModel
}
