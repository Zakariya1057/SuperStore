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
    var name: String
    var type: SearchType
    var textSearch: Bool = false
    
    func getSearchObject(_ searchType: String) -> SearchHistory{
        // Returns Realms Class
        let history = SearchHistory()
        history.name = self.name
        history.id = self.id
        history.searchType = searchType
        history.type = self.type.rawValue
        history.textSearch = self.textSearch
        
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
    var perPage: Int
    var nextPageUrl: String?
    var currentPageUrl: String
    var prevPageUrl:String?
    var moreAvailable: Bool
}
