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
    
    func getSuggestions(query: String, completionHandler: @escaping ( _ suggestions: [SuggestionModel], _ error: String?) -> Void){
        searchAPI.getSuggestions(query: query, completionHandler: completionHandler)
    }
    
    func getResults(data: KeyValuePairs<String, Any>, completionHandler: @escaping (_ error: String?) -> Void){
//        favouriteAPI.deleteFavourite(productID: productID, completionHandler: completionHandler)
    }
    
}

protocol SearchRequestProtocol {
    func getSuggestions(query: String, completionHandler: @escaping ( _ suggestions: [SuggestionModel], _ error: String?) -> Void)
    func getResults(data: KeyValuePairs<String, Any>, completionHandler: @escaping ( _ ResultsModel: ResultsModel?, _ error: String?) -> Void)
}
