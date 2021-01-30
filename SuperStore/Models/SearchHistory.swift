//
//  SearchRealmModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 10/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class SearchHistory: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var searchType: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var textSearch: Bool = false
    @objc dynamic var usedAt: Date = Date()
    
    override static func indexedProperties() -> [String] {
        return ["id", "searchType", "name"]
    }
}
