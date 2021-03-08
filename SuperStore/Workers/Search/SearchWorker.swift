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
    
    init(searchAPI: SearchRequestProtocol) {
        self.searchAPI = searchAPI
    }
    
    func getSuggestions(storeTypeID: Int, query: String, completionHandler: @escaping ( _ suggestions: [SuggestionModel], _ error: String?) -> Void){
        searchAPI.getSuggestions(storeTypeID: storeTypeID, query: query, completionHandler: completionHandler)
    }
    
    func getProductResults(data: ProductQueryModel, completionHandler: @escaping (_ ResultsModel: ProductResultsModel?, _ error: String?) -> Void){
        searchAPI.getProductResults(data: data, completionHandler: completionHandler)
    }
    
}

protocol SearchRequestProtocol {
    func getSuggestions(storeTypeID: Int, query: String, completionHandler: @escaping ( _ suggestions: [SuggestionModel], _ error: String?) -> Void)
    func getProductResults(data: ProductQueryModel, completionHandler: @escaping ( _ ResultsModel: ProductResultsModel?, _ error: String?) -> Void)
}
