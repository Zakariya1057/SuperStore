//
//  ShowSuggestionsInteractor.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowSuggestionsBusinessLogic
{
    func getSuggestions(request: ShowSuggestions.GetSuggestions.Request)
    func getRecentSuggestions(request: ShowSuggestions.GetRecentSuggestions.Request)
    
    func suggestionSelected(suggestion: SuggestionModel)
    
    func textSearch(query: String)
    
    func getSelectedListID() -> Int?
}

protocol ShowSuggestionsDataStore
{
    var searchQueryRequest: SearchQueryRequest? { get set }
    var selectedListID: Int? { get set }
    var supermarketChainID: Int { get }
}

class ShowSuggestionsInteractor: ShowSuggestionsBusinessLogic, ShowSuggestionsDataStore
{
    var presenter: ShowSuggestionsPresentationLogic?
    var searchWorker: SearchWorker = SearchWorker(searchAPI: SearchAPI())
    
    var userSession = UserSessionWorker()
    
    var searchQueryRequest: SearchQueryRequest? = nil
    
    var selectedListID: Int?
    
    var supermarketChainID: Int {
        return userSession.getSupermarketChainID()
    }
    
    var regionID: Int {
        return userSession.getRegion()
    }
    
    func getSuggestions(request: ShowSuggestions.GetSuggestions.Request)
    {
        let offline: Bool = !userSession.isOnline()
        
        searchWorker.getSuggestions(supermarketChainID: supermarketChainID, query: request.query, offline: offline) { (suggestions: [SuggestionModel], error: String?) in
            var response = ShowSuggestions.GetSuggestions.Response(suggestions: suggestions, error: error)
            
            if error != nil {
                response.offline = !self.userSession.isOnline()
            }
            
            self.presenter?.presentSuggestions(response: response)
        }
    }
    
    func getRecentSuggestions(request: ShowSuggestions.GetRecentSuggestions.Request){
        searchWorker.getRecentSuggestions(supermarketChainID: supermarketChainID, limit: request.limit) { (suggestions: [SuggestionModel], error: String?) in
            let response = ShowSuggestions.GetRecentSuggestions.Response(suggestions: suggestions, error: error)
            self.presenter?.presentRecentSuggestions(response: response)
        }
    }
}

extension ShowSuggestionsInteractor {
    func suggestionSelected(suggestion: SuggestionModel){
        let type: String = suggestion.type.rawValue
        
        searchQueryRequest = SearchQueryRequest(
            query: suggestion.name,
            type: type,
            textSearch: suggestion.textSearch,
            supermarketChainID: supermarketChainID,
            regionID: regionID
        )
        
        searchWorker.suggestionSelected(suggestion: suggestion)
    }
    
    func textSearch(query: String){
        let suggestion = SuggestionModel(id: 0, name: query, type: .product, textSearch: true, supermarketChainID: supermarketChainID)
        searchWorker.suggestionSelected(suggestion: suggestion)
        
        searchQueryRequest = SearchQueryRequest(
            query: query,
            type: SearchType.product.rawValue,
            textSearch: true,
            supermarketChainID: supermarketChainID,
            regionID: regionID
        )
    }
}

extension ShowSuggestionsInteractor {
    func getSelectedListID() -> Int? {
        return selectedListID
    }
}
