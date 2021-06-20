//
//  NutritionModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 20/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class NutritionModel: ChildNutritionModel {
    var childNutritions: [ChildNutritionModel] = []
    
    init(name: String, grams: String, percentage: String, childNutritions: [ChildNutritionModel] = []) {
        self.childNutritions = childNutritions
        super.init(name: name, grams: grams, percentage: percentage)
    }
}

class ChildNutritionModel {
    var name: String
    var grams: String
    var percentage: String
    
    init(name: String, grams: String, percentage: String) {
        self.name = name
        self.grams = grams
        self.percentage = percentage
    }
}
