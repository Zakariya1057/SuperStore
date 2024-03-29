//
//  FavouritesPresenter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FavouritesPresentationLogic
{
    func presentFavourites(response: Favourites.GetFavourites.Response)
    func presentDeleteFavourite(response: Favourites.DeleteFavourite.Response)
}

class FavouritesPresenter: FavouritesPresentationLogic
{
    weak var viewController: FavouritesDisplayLogic?

    func presentFavourites(response: Favourites.GetFavourites.Response)
    {
        let viewModel = Favourites.GetFavourites.ViewModel(products: response.products, error: response.error, offline: response.offline)
        viewController?.displayFavourites(viewModel: viewModel)
    }
    
    func presentDeleteFavourite(response: Favourites.DeleteFavourite.Response)
    {
        let viewModel = Favourites.DeleteFavourite.ViewModel(error: response.error)
        viewController?.displayDeleteFavourite(viewModel: viewModel)
    }
}
