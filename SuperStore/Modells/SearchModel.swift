//
//  SuggestionModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct SuggestionModel {
    var id: Int
    var name: String
    var type: SearchType
    var textSearch: Bool = false
    
    var storeTypeID: Int? = nil
    
    var visited: Bool = false
    var visitedAt: Date? = nil
}

struct ProductResultsModel {
    var products: [ProductModel]
    var paginate: PaginateResultsModel?
}

struct StoreResultsModel {
    var stores: [ProductModel]
}

struct PromotionResultsModel {
    var promotion: [PromotionModel]
}

struct PaginateResultsModel {
    var from: Int
    var current: Int
    var to: Int
    
    var perPage: Int

    var moreAvailable: Bool
}

struct SearchRefine {
    var brands: [String]
    var categories: [String]
}

enum SearchType: String {
    case store
    case product
    case promotion
    case childCategory
    case parentCategory
}

