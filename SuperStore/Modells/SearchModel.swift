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
}

struct ResultsModel {
    
}

enum SearchType: String {
    case store
    case product
    case promotion
    case childCategory
    case parentCategory
}
