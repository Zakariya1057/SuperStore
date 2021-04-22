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

    func createSuggestions(suggestions: [SuggestionModel], storeTypeID: Int){
        for suggestion in suggestions {
            createSuggestion(suggestion: suggestion, storeTypeID: storeTypeID)
        }
    }
    
    var defaultSuggestions: [SuggestionModel] = [
        SuggestionModel(id: 1, name: "Bakery", type: .parentCategory, storeTypeID: 2, visited: true, visitedAt: Date()),
        SuggestionModel(id: 1, name: "Dairy & Eggs", type: .parentCategory, storeTypeID: 2, visited: true, visitedAt: Date()),
        SuggestionModel(id: 1, name: "Fruits & Vegetables", type: .parentCategory, storeTypeID: 2, visited: true, visitedAt: Date()),
        SuggestionModel(id: 2, name: "Real Canadian Superstore Offers", type: .storeSale, storeTypeID: 2, visited: true, visitedAt: Date()),
        SuggestionModel(id: 2, name: "Real Canadian Superstore", type: .store, storeTypeID: 2, visited: true, visitedAt: Date()),

        
        SuggestionModel(id: 1, name: "Asda", type: .store, storeTypeID: 1, visited: true, visitedAt: Date()),
        SuggestionModel(id: 1, name: "Fruit", type: .parentCategory, storeTypeID: 1, visited: true, visitedAt: Date()),
        SuggestionModel(id: 1, name: "Coffee, Tea & Hot Chocolate", type: .parentCategory, storeTypeID: 1, visited: true, visitedAt: Date()),
        SuggestionModel(id: 1, name: "Rice, Pasta & Noodles", type: .parentCategory, storeTypeID: 1, visited: true, visitedAt: Date()),
        SuggestionModel(id: 1, name: "Laundry", type: .parentCategory, storeTypeID: 1, visited: true, visitedAt: Date()),
    ]
    
    
    func createSuggestion(suggestion: SuggestionModel, storeTypeID: Int){
        
        let name: String = suggestion.name
        let type: String = suggestion.type.rawValue
        
        if getSuggestionObject(name: name, type: type) != nil {
//            print("Duplicate Search Item Found. Ignoring")
        } else {
            try? realm?.write({
                let savedSuggestion = SuggestionObject()
                
                savedSuggestion.id = suggestion.id
                savedSuggestion.name = suggestion.name
                savedSuggestion.type = suggestion.type.rawValue
                savedSuggestion.textSearch = suggestion.textSearch
                savedSuggestion.storeTypeID = suggestion.storeTypeID ?? storeTypeID
                
                savedSuggestion.visited = suggestion.visited
                savedSuggestion.visitedAt = suggestion.visitedAt
                
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
        
        var savedSuggestion: SuggestionObject? = nil
        
        if suggestion.textSearch {
            if let savedSelectedSuggestion = getSuggestionObject(name: suggestion.name, type: suggestion.type.rawValue){
                savedSuggestion = savedSelectedSuggestion
            } else {
                createSuggestion(suggestion: suggestion, storeTypeID: suggestion.storeTypeID!)
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
    func getRecentSuggestions(storeTypeID: Int, limit count: Int) -> [SuggestionModel] {
        // Get last X suggestions
        
        var limit: Int = count
        
        var recentSuggestions: [SuggestionModel] = []
        
        let savedSuggestions = realm?.objects(SuggestionObject.self).filter("storeTypeID = %@ AND visited = %@", storeTypeID, true).sorted(byKeyPath: "visitedAt", ascending: false)
        
        if let savedSuggestions = savedSuggestions {
            
            if savedSuggestions.count == 0 {
                createSuggestions(suggestions: defaultSuggestions, storeTypeID: storeTypeID)
                
                for suggestion in defaultSuggestions {
                    if suggestion.storeTypeID == storeTypeID {
                        recentSuggestions.append(suggestion)
                    }
                }
                
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
