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

struct PaginateResultsModel {
    var from: Int
    var current: Int
    var to: Int
    var per_page: Int
    var next_page_url: String?
    var current_page_url: String
    var prev_page_url:String?
    var more_available: Bool
}
