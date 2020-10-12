//
//  SearchModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct SearchModel {
    var id: Int
    var name:String
    var type: SearchType
    
    func getSearchObject(_ searchType: String) -> SearchHistory{
        // Returns Realms Class
        let history = SearchHistory()
        history.name = self.name
        history.id = self.id
        history.searchType = searchType
        history.type = self.type.rawValue
        
        return history
    }
}

struct FilterModel {
    var categories: [FilterItemModel]
    var brands: [FilterItemModel]
}

struct FilterItemModel {
    var name: String
    var quantity: Int
}
