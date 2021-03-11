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
}
