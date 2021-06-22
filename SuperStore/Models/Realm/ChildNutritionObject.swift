//
//  NutritionObject.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ChildNutritionObject: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var grams: String? = nil
    @objc dynamic var percentage: String? = nil

    func getNutritionModel() -> NutritionModel {
        return NutritionModel(name: name, grams: grams, percentage: percentage)
    }
}
