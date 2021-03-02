//
//  SearchDat.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

// Suggestions

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

// Product
struct ProductResultsDataResponse: Decodable {
    let data: ProductResultsData
}

struct ProductResultsData: Decodable {
    var products: [ProductData]
    let paginate: PaginateResultsData?
}

// Store
struct StoreResultsDataResponse: Decodable {
    let data: StoreResultsData
}

struct StoreResultsData: Decodable {
    var stores: [StoreData]
}

// Promotion

//struct SearchResultsDataResponse: Decodable {
//    let data: SearchResultsData
//}
//
//struct SearchResultsData: Decodable {
//    let stores:[StoreData]
//    let products:[ProductData]
//    let paginate: PaginateResultsData?
//}
//
//struct FilterResultsData: Decodable {
//    let brands:[String: Int]?
//    let categories:[String: Int]?
//}
//

struct PaginateResultsData: Decodable {
    var from: Int
    var current: Int
    var to: Int
    var per_page: Int
    var next_page_url: String?
    var current_page_url: String
    var prev_page_url:String?
    var more_available: Bool
}
