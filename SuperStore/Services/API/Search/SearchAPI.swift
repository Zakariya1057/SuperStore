//
//  SearchAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Alamofire

class SearchAPI: API, SearchRequestProtocol {
    
    func getSuggestions(supermarketChainID: Int, query: String, completionHandler: @escaping ([SuggestionModel], String?) -> Void) {
        let url = Config.Routes.Search.Suggestions
        
        requestWorker.post(url: url, data: ["query": query, "supermarket_chain_id": supermarketChainID]) { (response: () throws -> Data) in
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
                completionHandler([], "Failed to get suggestions. Decoding error, please try again later.")
            }
        }
    }
    
    func getProductResults(data: SearchQueryRequest, page: Int, completionHandler: @escaping (ProductResultsModel?, String?) -> Void) {
        
        let url = Config.Routes.Search.Results.Product + "?page=\(page)"
        
        let queryData: Parameters = [
            "query": data.query,
            
            "type": data.type,
            "sort": data.sort,
            "order": data.order,
            
            "dietary": data.dietary,
            
            "product_group": data.productGroup,
            "availability_type": data.availabilityType,
            
            "brand": data.brand,
            "promotion": data.promotion,
            
            "text_search": data.textSearch,
            
            "supermarket_chain_id": data.supermarketChainID,
            "region_id": data.regionID,
        ]
        
        requestWorker.post(url: url, data: queryData) { (response: () throws -> Data) in
            do {
                let data = try response()
                
                let productResultsDataResponse =  try self.jsonDecoder.decode(ProductResultsDataResponse.self, from: data)
                let results = self.createproductResultsModel(productResultsDataResponse: productResultsDataResponse)
                
                completionHandler(results, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(nil, errorMessage)
            } catch {
                print(error)
                completionHandler(nil, "Failed to get products. Please try again later.")
            }
        }
    }
}

extension SearchAPI {
    private func createproductResultsModel(productResultsDataResponse: ProductResultsDataResponse) -> ProductResultsModel? {
        let productResultsData = productResultsDataResponse.data
        let products: [ProductModel] = productResultsData.products.map { (product: ProductData) in
            return product.getProductModel()
        }
        
        let paginate = productResultsData.paginate.getPaginateResultsModel()
        
        return ProductResultsModel(products: products, paginate: paginate)
    }
}

extension SearchAPI {
    private func createSuggestionModels(suggestionDataResponse: SearchSuggestionsDataResponse) -> [SuggestionModel]{
        let suggestionData = suggestionDataResponse.data
        var suggestions: [SuggestionModel] = []
        
        suggestions.append(contentsOf: createSuggestionModel(suggestionsData: suggestionData.stores, type: .store))
        suggestions.append(contentsOf: createSuggestionModel(suggestionsData: suggestionData.store_sales, type: .storeSale))
        suggestions.append(contentsOf: createSuggestionModel(suggestionsData: suggestionData.promotions, type: .promotion))
        
        suggestions.append(contentsOf: createSuggestionModel(suggestionsData: suggestionData.product_groups, type: .productGroup))
        suggestions.append(contentsOf: createSuggestionModel(suggestionsData: suggestionData.child_categories, type: .childCategory))
        suggestions.append(contentsOf: createSuggestionModel(suggestionsData: suggestionData.parent_categories, type: .parentCategory))

        suggestions.append(contentsOf: createSuggestionModel(suggestionsData: suggestionData.brands, type: .brand))
        suggestions.append(contentsOf: createSuggestionModel(suggestionsData: suggestionData.corrections, type: .product, textSearch: true))
        suggestions.append(contentsOf: createSuggestionModel(suggestionsData: suggestionData.products, type: .product))
 
        return suggestions
    }
    
    private func createSuggestionModel(suggestionsData: [SearchOptionData], type: SearchType, textSearch: Bool = false) -> [SuggestionModel] {
        return suggestionsData.map { (suggestion: SearchOptionData) in
            return SuggestionModel(id: suggestion.id, name: suggestion.name, type: type, textSearch: textSearch)
        }
    }
}
