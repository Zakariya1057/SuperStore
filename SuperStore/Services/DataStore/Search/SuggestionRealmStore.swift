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
    
    private func getSuggestionObject(name: String, type: String, textSearch: Bool) -> SuggestionObject? {
        return realm?.objects(SuggestionObject.self).filter("textSearch = %@ AND type = %@ AND name = %@", textSearch, type, name).first
    }

    func createSuggestions(suggestions: [SuggestionModel], storeTypeID: Int){
        for suggestion in suggestions {
            createSuggestion(suggestion: suggestion, storeTypeID: storeTypeID)
        }
    }
    
    func createSuggestion(suggestion: SuggestionModel, storeTypeID: Int){
        
        let name: String = suggestion.name
        let type: String = suggestion.type.rawValue
        let textSearch: Bool = suggestion.textSearch
        
        if getSuggestionObject(name: name, type: type, textSearch: textSearch) != nil {
            print("Duplicate Search Item Found. Ignoring")
        } else {
            try? realm?.write({
                let savedSuggestion = SuggestionObject()
                
                savedSuggestion.id = suggestion.id
                savedSuggestion.name = suggestion.name
                savedSuggestion.type = suggestion.type.rawValue
                savedSuggestion.textSearch = suggestion.textSearch
                savedSuggestion.storeTypeID = storeTypeID
                
                realm?.add(savedSuggestion)
            })
        }
    }
    
    func searchSuggestion(storeTypeID: Int, query: String) -> [SuggestionModel] {
        let savedSuggestions = realm?.objects(SuggestionObject.self).filter("storeTypeID = %@ AND name CONTAINS[c] %@", storeTypeID, query)
        
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
        let textSearch: Bool = suggestion.textSearch
        
        let savedSuggestion = realm?.objects(SuggestionObject.self)
            .filter("id  = %@ AND name = %@ AND type = %@ AND textSearch = %@", id, name, type, textSearch).first
        
        if let savedSuggestion = savedSuggestion {
            try? realm?.write({
                savedSuggestion.visited = true
                savedSuggestion.visitedAt = Date()
            })
        }
    }
}

extension SuggestionRealmStore {
    func getRecentSuggestions(storeTypeID: Int, limit count: Int) -> [SuggestionModel] {
        // Get last X suggestions
        var limit: Int = count
        
        var recentSuggestions: [SuggestionModel] = []
        
        let savedSuggestions = realm?.objects(SuggestionObject.self).filter("visited = %@", true).sorted(byKeyPath: "visitedAt", ascending: false)
        
        if let savedSuggestions = savedSuggestions {
            
            if savedSuggestions.count == 0 {
                recentSuggestions = [
                    SuggestionModel(id: 1, name: "Asda", type: .store),
                    SuggestionModel(id: 1, name: "Fruit", type: .parentCategory),
                    SuggestionModel(id: 1, name: "Apples", type: .childCategory),
                ]
                
                createSuggestions(suggestions: recentSuggestions, storeTypeID: storeTypeID)
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
