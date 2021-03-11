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
    var searchSuggestionStore: SearchStoreProtocol
    
    init(searchAPI: SearchRequestProtocol) {
        self.searchAPI = searchAPI
        self.searchSuggestionStore = SuggestionRealmStore()
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
    
    func getProductResults(data: ProductQueryModel, completionHandler: @escaping (_ ResultsModel: ProductResultsModel?, _ error: String?) -> Void){
        searchAPI.getProductResults(data: data, completionHandler: completionHandler)
    }
    
}

protocol SearchRequestProtocol {
    func getSuggestions(storeTypeID: Int, query: String, completionHandler: @escaping ( _ suggestions: [SuggestionModel], _ error: String?) -> Void)
    func getProductResults(data: ProductQueryModel, completionHandler: @escaping ( _ ResultsModel: ProductResultsModel?, _ error: String?) -> Void)
}

protocol SearchStoreProtocol {
    func createSuggestions(suggestions: [SuggestionModel], storeTypeID: Int)
    func createSuggestion(suggestion: SuggestionModel, storeTypeID: Int)
    
    func searchSuggestion(storeTypeID: Int, query: String) -> [SuggestionModel]
}
