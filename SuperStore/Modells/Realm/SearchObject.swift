//
//  SearchObject.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class SuggestionObject: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var textSearch: Bool = false
    
    @objc dynamic var storeTypeID: Int = 1
    
    @objc dynamic var visited: Bool = false
    
    @objc dynamic var visitedAt: Date? = nil
    
    func getSuggestionModel() -> SuggestionModel {
        let searchType: SearchType = SearchType.init(rawValue: type)!
        return SuggestionModel(id: id, name: name, type: searchType, textSearch: textSearch)
    }
}
