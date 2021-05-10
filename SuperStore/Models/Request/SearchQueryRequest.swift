//
//  SearchQueryModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct SearchQueryRequest {
    var storeTypeID: Int
    var query: String
    var type: String
    var sort: String = ""
    var order: String = ""
    var promotion: String = ""
    var dietary: String = ""
    var brand: String = ""
    var productGroup: String = ""
    var textSearch: Bool = false
    
    var refineSort: Bool = false
}
