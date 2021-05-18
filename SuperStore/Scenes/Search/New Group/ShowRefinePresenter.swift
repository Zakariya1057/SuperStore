//
//  ShowRefinePresenter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowRefinePresentationLogic
{
    func presentSelectedOptions(response: ShowRefine.GetSelectedOptions.Response)
    func presentSearchRefine(response: ShowRefine.GetSearchRefine.Response)
}

class ShowRefinePresenter: ShowRefinePresentationLogic
{
    weak var viewController: ShowRefineDisplayLogic?

    func presentSelectedOptions(response: ShowRefine.GetSelectedOptions.Response)
    {
        let viewModel = ShowRefine.GetSelectedOptions.ViewModel(selectedRefineOptions: response.selectedRefineOptions)
        viewController?.displaySelectedOptions(viewModel: viewModel)
    }
    
    func presentSearchRefine(response: ShowRefine.GetSearchRefine.Response) {
        let refineBrands: [RefineBrandOptionModel] = response.searchRefine.brands.compactMap({RefineBrandOptionModel(name: $0, checked: false)})
        
        let refineProductGroups: [RefineProductGroupOptionModel] = response.searchRefine.productGroups.compactMap({RefineProductGroupOptionModel(name: $0, checked: false)})
        
        let refinePromotions: [RefinePromotionOptionModel] = response.searchRefine.promotions.compactMap({RefinePromotionOptionModel(name: $0, checked: false)})
        
        let availabilityType: [RefineAvailabilityTypeOptionModel] = response.searchRefine.availabilityType.compactMap({RefineAvailabilityTypeOptionModel(name: $0, checked: false)})
        
        let viewModel = ShowRefine.GetSearchRefine.ViewModel(
            availabilityType: availabilityType,
            brands: refineBrands,
            productGroups: refineProductGroups,
            promotions: refinePromotions)
        viewController?.displaySearchRefine(viewModel: viewModel)
    }
}
