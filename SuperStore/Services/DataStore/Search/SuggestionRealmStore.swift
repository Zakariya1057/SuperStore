//
//  SearchSuggestionRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class SuggestionRealmStore: DataStore, SuggestionStoreProtocol {
    
    private func getSuggestionObject(name: String, type: String) -> SuggestionObject? {
        return realm?.objects(SuggestionObject.self).filter("type = %@ AND name = %@", type, name).first
    }

    func createSuggestions(suggestions: [SuggestionModel], supermarketChainID: Int){
        for suggestion in suggestions {
            createSuggestion(suggestion: suggestion, supermarketChainID: supermarketChainID)
        }
    }
    
    var defaultSuggestions: [SuggestionModel] = [
        SuggestionModel(id: 1, name: "Bakery", type: .parentCategory, supermarketChainID: 2, visited: true, visitedAt: Date()),
        SuggestionModel(id: 1, name: "Dairy & Eggs", type: .parentCategory, supermarketChainID: 2, visited: true, visitedAt: Date()),
        SuggestionModel(id: 1, name: "Fruits & Vegetables", type: .parentCategory, supermarketChainID: 2, visited: true, visitedAt: Date()),
        SuggestionModel(id: 2, name: "Offers", type: .storeSale, supermarketChainID: 2, visited: true, visitedAt: Date()),
        SuggestionModel(id: 2, name: "Nearby Stores", type: .store, supermarketChainID: 2, visited: true, visitedAt: Date())
    ]
    
    
    func createSuggestion(suggestion: SuggestionModel, supermarketChainID: Int){
        
        let name: String = suggestion.name
        let type: String = suggestion.type.rawValue
        
        if getSuggestionObject(name: name, type: type) != nil {
            
        } else {
            try? realm?.write({
                let savedSuggestion = SuggestionObject()
                
                savedSuggestion.id = suggestion.id
                savedSuggestion.name = suggestion.name
                savedSuggestion.type = suggestion.type.rawValue
                savedSuggestion.textSearch = suggestion.textSearch
                savedSuggestion.supermarketChainID = suggestion.supermarketChainID ?? supermarketChainID
                
                savedSuggestion.visited = suggestion.visited
                savedSuggestion.visitedAt = suggestion.visitedAt
                
                realm?.add(savedSuggestion)
            })
        }
    }
    
    func searchSuggestion(supermarketChainID: Int, query: String) -> [SuggestionModel] {
        let savedSuggestions = realm?.objects(SuggestionObject.self).filter("supermarketChainID = %@ AND name CONTAINS[c] %@", supermarketChainID, query)
        
        if let savedSuggestions = savedSuggestions {
            return savedSuggestions.map{ $0.getSuggestionModel() }
        }
        
        return []
    }
    
    func suggestionSelected(suggestion: SuggestionModel){
        // Find realm suggestion mark as pressed.
        
        let id: Int = suggestion.id
        let name: String = suggestion.name
        let type: String = suggestion.type.rawValue
        
        var savedSuggestion: SuggestionObject? = nil
        
        if suggestion.textSearch {
            if let savedSelectedSuggestion = getSuggestionObject(name: suggestion.name, type: suggestion.type.rawValue){
                savedSuggestion = savedSelectedSuggestion
            } else {
                createSuggestion(suggestion: suggestion, supermarketChainID: suggestion.supermarketChainID!)
                if let savedSelectedSuggestion = getSuggestionObject(name: suggestion.name, type: suggestion.type.rawValue){
                    savedSuggestion = savedSelectedSuggestion
                }
            }
            
        }
        
        if savedSuggestion == nil {
            savedSuggestion = realm?.objects(SuggestionObject.self).filter("id = %@ AND name = %@ AND type = %@", id, name, type).first
        }
       
        if let savedSuggestion = savedSuggestion {
            try? realm?.write({
                savedSuggestion.visited = true
                savedSuggestion.visitedAt = Date()
            })
        }
        
    }
}

extension SuggestionRealmStore {
    func getRecentSuggestions(supermarketChainID: Int, limit count: Int) -> [SuggestionModel] {
        // Get last X suggestions
        
        var limit: Int = count
        
        var recentSuggestions: [SuggestionModel] = []
        
        let savedSuggestions = realm?.objects(SuggestionObject.self).filter("visited = %@", true).sorted(byKeyPath: "visitedAt", ascending: false)
        
        if let savedSuggestions = savedSuggestions {
            
            if savedSuggestions.count == 0 {
                createSuggestions(suggestions: defaultSuggestions, supermarketChainID: supermarketChainID)
                recentSuggestions = defaultSuggestions
            } else {
                if savedSuggestions.count < count {
                    limit = savedSuggestions.count
                }
                
                for index in 0 ..< limit {
                    recentSuggestions.append(savedSuggestions[index].getSuggestionModel())
                }
            }

        }
        
        return recentSuggestions
    }
}

extension SuggestionRealmStore {
    func clearSearchCache() {
        try? realm?.write({
            if let suggestions = realm?.objects(SuggestionObject.self) {
                realm?.delete(suggestions)
            }
        })
    }
}
