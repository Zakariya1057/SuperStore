//
//  RefineModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class SelectedRefineOptions {
    var sort: [RefineSortOptionModel] = []
    var brand: [RefineBrandOptionModel] = []
    var category: [RefineCategoryOptionModel] = []
    var dietary: [RefineDietaryOptionModel] = []
    var promotion: [RefinePromotionOptionModel] = []
}

class RefineSearchModel {
    var sort: RefineSortGroupModel
    var category: RefineCategoryGroupModel
    var brand: RefineBrandGroupModel
    var promotion: RefinePromotionGroupModel
    var dietary: RefineDietaryGroupModel
    
    init(sort: RefineSortGroupModel, promotion: RefinePromotionGroupModel, category: RefineCategoryGroupModel, brand: RefineBrandGroupModel,dietary: RefineDietaryGroupModel) {
        self.sort = sort
        self.promotion = promotion
        self.brand = brand
        self.category = category
        self.dietary = dietary
    }
}

class RefineGroupModel {
    var name: String
    var selectionType: RefineSelctionType
    var options: [RefineOptionModel]
    
    init(name: String, selectionType: RefineSelctionType, options: [RefineOptionModel]) {
        self.name = name
        self.options = options
        self.selectionType = selectionType
    }
}


// Sort Model
class RefineSortGroupModel: RefineGroupModel { }

// Brand Model
class RefineBrandGroupModel: RefineGroupModel { }

// Category Model
class RefineCategoryGroupModel: RefineGroupModel { }

// Dietary Model
class RefineDietaryGroupModel: RefineGroupModel { }

// Promotion Model
class RefinePromotionGroupModel: RefineGroupModel { }

// Selection Type. Multiple Option In Groups
enum RefineSelctionType {
    case single
    case multiple
}

// Options Within Group
class RefineOptionModel: Equatable {
    var name: String
    var checked: Bool
    
    init(name: String, checked: Bool) {
        self.name = name
        self.checked = checked
    }
    
    static func == (lhs: RefineOptionModel, rhs: RefineOptionModel) -> Bool {
        return
            lhs.name == rhs.name
    }
}

//MARK: - Sort Option Model
class RefineSortOptionModel: RefineOptionModel {
    var order: RefineOrderType
    var type: RefineSortType
    
    init(name: String, checked: Bool, order: RefineOrderType, type: RefineSortType) {
        self.order = order
        self.type = type
        super.init(name: name, checked: checked)
    }
    
    static func == (lhs: RefineSortOptionModel, rhs: RefineSortOptionModel) -> Bool {
        return
            lhs.order == rhs.order &&
            lhs.type == rhs.type &&
            lhs.name == rhs.name
    }
}

enum RefineOrderType: String {
    case asc = "asc"
    case desc = "desc"
}

enum RefineSortType: String {
    case price = "price"
    case rating = "rating"
}


//MARK: - Dietary Option Model
class RefineDietaryOptionModel: RefineOptionModel {
    var type: RefinDieteryType
    
    init(name: String, checked: Bool, type: RefinDieteryType) {
        self.type = type
        super.init(name: name, checked: checked)
    }
    
    static func == (lhs: RefineDietaryOptionModel, rhs: RefineDietaryOptionModel) -> Bool {
        return
            lhs.type == rhs.type &&
            lhs.name == rhs.name
    }
}

enum RefinDieteryType {
    case halal
    case vegan
    case vegetarian
    case kosher
    case noPeanuts
    case noShellfish
    case noGluten
    case noMilk
    case noLactose
    case noEgg
    case lowSalt
    case lowFat
    case alcoholFree
    case organic
    case noAddedSugar
    case noCaffeine
}

//MARK: - Brand Option Model

class RefineBrandOptionModel: RefineOptionModel { }

//MARK: - Category Option Model

class RefineCategoryOptionModel: RefineOptionModel { }

//MARK: - Promotion Option Model

class RefinePromotionOptionModel: RefineOptionModel { }
