//
//  RefineModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class SelectedRefineOptions {
    var brand: [RefineBrandOptionModel] = []
    var productGroup: [RefineProductGroupOptionModel] = []
    var dietary: [RefineDietaryOptionModel] = []
    var promotion: [RefinePromotionOptionModel] = []
    var availabilityType: [RefineAvailabilityTypeOptionModel] = []
}

class RefineSearchModel {
    var availabilityType: RefineAvailabilityTypeGroupModel
    var productGroup: RefineProductGroupGroupModel
    var brand: RefineBrandGroupModel
    var promotion: RefinePromotionGroupModel
    var dietary: RefineDietaryGroupModel
    
    init(
        availabilityType: RefineAvailabilityTypeGroupModel,
        promotion: RefinePromotionGroupModel,
        productGroup: RefineProductGroupGroupModel,
        brand: RefineBrandGroupModel,
        dietary: RefineDietaryGroupModel
    ) {
        self.availabilityType = availabilityType
        self.promotion = promotion
        self.brand = brand
        self.productGroup = productGroup
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

//MARK: - Brand Model
class RefineBrandGroupModel: RefineGroupModel { }

//MARK: - Category Model
class RefineProductGroupGroupModel: RefineGroupModel { }

//MARK: - Dietary Model
class RefineDietaryGroupModel: RefineGroupModel { }

//MARK: - Promotion Model
class RefinePromotionGroupModel: RefineGroupModel { }

//MARK: - Availability Type Model
class RefineAvailabilityTypeGroupModel: RefineGroupModel  { }


// Selection Type. Multiple Option In Groups
enum RefineSelctionType {
    case single
    case multiple
}

//MARK: - Options Within Group
class RefineOptionModel: Equatable {
    var name: String
    var checked: Bool
    
    init(name: String, checked: Bool = false) {
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
    var type: RefineSortType
    var order: RefineOrderType?
    
    init(name: String, type: RefineSortType, order: RefineOrderType? = nil) {
        self.type = type
        self.order = order
        super.init(name: name, checked: false)
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
    case relevance = "relevance"
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

class RefineProductGroupOptionModel: RefineOptionModel { }

//MARK: - Promotion Option Model

class RefinePromotionOptionModel: RefineOptionModel { }

//MARK: - Availability Type Option Model

class RefineAvailabilityTypeOptionModel: RefineOptionModel {}
