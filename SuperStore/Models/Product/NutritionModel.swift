//
//  NutritionModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 20/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct NutritionModel {
    var name: String
    var grams: String?
    var percentage: String?
    var childNutritions: [NutritionModel] = []
}

