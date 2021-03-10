//
//  ShowProductResultsPresenter.swift
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

protocol ShowProductResultsPresentationLogic
{
    func presentResults(response: ShowProductResults.GetResults.Response)
    func presentListItems(response: ShowProductResults.GetListItems.Response)
    func presentListItemCreated(response: ShowProductResults.CreateListItem.Response)
    func presentListItemUpdated(response: ShowProductResults.UpdateListItem.Response)
}

class ShowProductResultsPresenter: ShowProductResultsPresentationLogic
{
    
    weak var viewController: ShowProductResultsDisplayLogic?
    
    func presentListItems(response: ShowProductResults.GetListItems.Response) {
        var listItems: [Int : ListItemModel] = [:]
        
        response.listItems.forEach { (listItem: ListItemModel) in
            listItems[listItem.productID] = listItem
        }
        
        let viewModel = ShowProductResults.GetListItems.ViewModel(listItems: listItems)
        viewController?.displayListItems(viewModel: viewModel)
    }
    
    func presentResults(response: ShowProductResults.GetResults.Response)
    {
        let viewModel = ShowProductResults.GetResults.ViewModel(products: response.products, error: response.error)
        viewController?.displayResults(viewModel: viewModel)
    }
    
    func presentListItemCreated(response: ShowProductResults.CreateListItem.Response) {
        let viewModel = ShowProductResults.CreateListItem.ViewModel(listItem: response.listItem, error: response.error)
        viewController?.displayListItemCreated(viewModel: viewModel)
    }
    
    func presentListItemUpdated(response: ShowProductResults.UpdateListItem.Response) {
        let viewModel = ShowProductResults.UpdateListItem.ViewModel(error: response.error)
        viewController?.displayListItemUpdated(viewModel: viewModel)
    }
}
