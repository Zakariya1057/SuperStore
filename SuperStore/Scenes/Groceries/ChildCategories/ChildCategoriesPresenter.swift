//
//  ChildCategoriesPresenter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ChildCategoriesPresentationLogic
{
    func presentCategories(response: ChildCategories.GetCategories.Response)
}

class ChildCategoriesPresenter: ChildCategoriesPresentationLogic
{
    weak var viewController: ChildCategoriesDisplayLogic?

    func presentCategories(response: ChildCategories.GetCategories.Response)
    {
        let displayedCategories = response.categories.map{ ChildCategories.GetCategories.ViewModel.DisplayedCategory(name: $0.name)}
        
        let viewModel =  ChildCategories.GetCategories.ViewModel(
            title: response.title,
            displayedCategories: displayedCategories,
            
            error: response.error,
            offline: response.offline
        )
        
        viewController?.displayCategories(viewModel: viewModel)
    }
}
