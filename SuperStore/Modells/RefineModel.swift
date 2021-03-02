//
//  RefineModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class RefineGroupModel {
    var name: String
    var options: [RefineOptionModel]
    
    init(name: String, options: [RefineOptionModel]) {
        self.name = name
        self.options = options
    }
}

class RefineSortByModel: RefineGroupModel { }

class RefineOptionModel {
    var name: String
    var checked: Bool
    
    init(name: String, checked: Bool) {
        self.name = name
        self.checked = checked
    }
}

// Sort Model
class RefineSortModel: RefineOptionModel {
    var order: RefineOrderType
    var type: RefineSortType
    
    init(name: String, checked: Bool, order: RefineOrderType, type: RefineSortType) {
        self.order = order
        self.type = type
        super.init(name: name, checked: checked)
    }
}

enum RefineOrderType {
    case asc
    case desc
}

enum RefineSortType {
    case price
    case rating
}

// Brand Model
class RefineBrandModel: RefineOptionModel { }

// Category Model
class RefineCategoryModel: RefineOptionModel { }

// Dietary Model
class RefineDietaryModel: RefineOptionModel { }
