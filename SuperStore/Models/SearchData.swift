//
//  SeriesData.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

// Search Suggestions
struct SearchSuggestionsDataResponse: Decodable {
    let data: SearchSuggestionsData
}

struct SearchSuggestionsData: Decodable {
    let stores:[SearchOptionData]
    let products:[SearchOptionData]
    let child_categories:[SearchOptionData]
    let parent_categories:[SearchOptionData]
}

struct SearchOptionData: Decodable {
    var id: Int
    var name: String
}

// Search Results
struct SearchResultsDataResponse: Decodable {
    let data: SearchResultsData
}

struct SearchResultsData: Decodable {
    let stores:[StoreData]
    let products:[ProductData]
    let filter:FilterResultsData?
}

struct FilterResultsData: Decodable {
    let brands:[String: Int]?
    let categories:[String: Int]?
}
