//
//  NutritionData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct NutritionData: Decodable {
    var name: String
    var grams: String?
    var percentage: String?
    var child_nutritions: [ChildNutritionData]
    
    func getNutritionModel() -> NutritionModel {
        return NutritionModel(
            name: name,
            grams: grams,
            percentage: percentage,
            childNutritions: child_nutritions.map{ $0.getNutritionModel()
        })
    }
}

struct ChildNutritionData: Decodable {
    var name: String
    var grams: String?
    var percentage: String?
    
    func getNutritionModel() -> NutritionModel {
        return NutritionModel(name: name, grams: grams, percentage: percentage)
    }
}
