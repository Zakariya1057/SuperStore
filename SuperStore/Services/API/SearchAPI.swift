//
//  SearchAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class SearchAPI: SearchRequestProtocol {
    
    let jsonDecoder = JSONDecoder()
    
    let requestWorker: RequestProtocol = RequestWorker()
    
    func getSuggestions(query: String, completionHandler: @escaping ([SuggestionModel], String?) -> Void) {
        let url = Config.Route.Search.Suggestions + "/" + query
        
        requestWorker.get(url: url) { (response: () throws -> Data) in
            do {
                let data = try response()
                let suggestionDataResponse =  try self.jsonDecoder.decode(SearchSuggestionsDataResponse.self, from: data)
                let suggestions = self.createSuggestionModels(suggestionDataResponse: suggestionDataResponse)
                completionHandler(suggestions, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler([], errorMessage)
            } catch {
                print(error)
                completionHandler([], "Failed to get product. Decoding error, please try again later.")
            }
        }
    }
    
    func getResults(data: KeyValuePairs<String, Any>, completionHandler: @escaping (ResultsModel?, String?) -> Void) {
        
    }
}

extension SearchAPI {
    private func createSuggestionModels(suggestionDataResponse: SearchSuggestionsDataResponse) -> [SuggestionModel]{
        let suggestionData = suggestionDataResponse.data
        var suggestions: [SuggestionModel] = []
        
        suggestions.append(contentsOf: createSuggestionModel(suggestionsData: suggestionData.child_categories, type: .childCategory))
        suggestions.append(contentsOf: createSuggestionModel(suggestionsData: suggestionData.parent_categories, type: .parentCategory))
        suggestions.append(contentsOf: createSuggestionModel(suggestionsData: suggestionData.products, type: .product))
        suggestions.append(contentsOf: createSuggestionModel(suggestionsData: suggestionData.stores, type: .store))
        
        return suggestions
    }
    
    private func createSuggestionModel(suggestionsData: [SearchOptionData], type: SearchType) -> [SuggestionModel] {
        return suggestionsData.map { (suggestion: SearchOptionData) in
            return SuggestionModel(id: suggestion.id, name: suggestion.name, type: type)
        }
    }
}
