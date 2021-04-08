//
//  SearchDat.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct SearchSuggestionsDataResponse: Decodable {
    let data: SearchSuggestionsData
}

struct SearchSuggestionsData: Decodable {
    let stores: [SearchOptionData]
    let store_sales: [SearchOptionData]
    let child_categories: [SearchOptionData]
    let parent_categories: [SearchOptionData]
    let products: [SearchOptionData]
    let promotions: [SearchOptionData]
    let brands: [SearchOptionData]
    
    let corrections: [SearchOptionData]
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
    let paginate: PaginateResultsData
}

// Store
struct StoreResultsDataResponse: Decodable {
    let data: StoreResultsData
}

struct StoreResultsData: Decodable {
    var stores: [StoreData]
}

struct PaginateResultsData: Decodable {
    var from: Int
    var current: Int
    var to: Int
    
    var per_page: Int

    var more_available: Bool
    
    func getPaginateResultsModel() -> PaginateResultsModel {
        return PaginateResultsModel(
            from: from,
            current: current,
            to: to,
            perPage: per_page,
            moreAvailable: more_available
        )
    }
}
