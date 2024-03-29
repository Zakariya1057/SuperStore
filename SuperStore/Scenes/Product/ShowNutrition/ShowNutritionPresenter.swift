//
//  ShowNutritionPresenter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 20/06/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowNutritionPresentationLogic
{
    func presentNutrition(response: ShowNutrition.GetNutritions.Response)
}

class ShowNutritionPresenter: ShowNutritionPresentationLogic
{
    weak var viewController: ShowNutritionDisplayLogic?
    
    func presentNutrition(response: ShowNutrition.GetNutritions.Response)
    {
        var nutritions: [NutritionModel] = []
        
        var calories: String?
        var sodium: String?
        var protein: String?
        
        for nutrition in response.nutritions {
            let name: String = nutrition.name.lowercased()
            
            if name.contains("sodium"){
                sodium = nutrition.grams
            } else if name.contains("calories") {
                calories = nutrition.grams
            } else if name.contains("protein") {
                protein = nutrition.grams
            } else {
                nutritions.append(nutrition)
            }
        }
        
        let viewModel = ShowNutrition.GetNutritions.ViewModel(
            calories: calories,
            sodium: sodium,
            protein: protein,
            nutritions: nutritions
        )
        
        viewController?.displayNutritions(viewModel: viewModel)
    }
}
