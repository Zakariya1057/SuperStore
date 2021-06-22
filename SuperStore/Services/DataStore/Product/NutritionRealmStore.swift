//
//  NutritionRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class NutritionRealmStore: DataStore {
    private func getReviewObject(productID: Int, userID: Int) -> ReviewObject? {
        return realm?.objects(ReviewObject.self).filter("productID = %@ AND userID = %@", productID, userID).first
    }
    
    func createNutritionObject(nutrition: NutritionModel) -> NutritionObject {
        let savedNutrition = NutritionObject()
        
        savedNutrition.name = nutrition.name
        savedNutrition.grams = nutrition.grams
        savedNutrition.percentage = nutrition.percentage
        
        for childNutrition in nutrition.childNutritions {
            let savedChildNutritions = createChildNutritionObject(nutrition: childNutrition)
            savedNutrition.childNutritions.append(savedChildNutritions)
        }
        
        return savedNutrition
    }
    
    func createChildNutritionObject(nutrition: NutritionModel) -> ChildNutritionObject {
        let savedNutrition = ChildNutritionObject()
        
        savedNutrition.name = nutrition.name
        savedNutrition.grams = nutrition.grams
        savedNutrition.percentage = nutrition.percentage

        return savedNutrition
    }
}
