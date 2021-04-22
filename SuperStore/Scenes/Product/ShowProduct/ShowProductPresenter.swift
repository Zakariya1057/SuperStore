//
//  ShowProductPresenter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowProductPresentationLogic
{
    func presentProduct(response: ShowProduct.GetProduct.Response)
    func presentFavourite(response: ShowProduct.UpdateFavourite.Response)
    func presentMonitoring(response: ShowProduct.UpdateMonitoring.Response)
    
    func presentListItem(response: ShowProduct.GetListItem.Response)
    func presentListItemCreated(response: ShowProduct.CreateListItem.Response)
    func presentListItemUpdated(response: ShowProduct.UpdateListItem.Response)
}

class ShowProductPresenter: ShowProductPresentationLogic
{
    
    weak var viewController: ShowProductDisplayLogic?

    func presentProduct(response: ShowProduct.GetProduct.Response)
    {
        
        var displayedProduct: ShowProduct.DisplayedProduct?
        
        if let product = response.product {
            displayedProduct = createDisplayedProduct(product: product)
        }
        
        let viewModel = ShowProduct.GetProduct.ViewModel(product: response.product, displayedProduct: displayedProduct, error: response.error, offline: response.offline)
        viewController?.displayProduct(viewModel: viewModel)
        
    }
    
    func presentFavourite(response: ShowProduct.UpdateFavourite.Response){
        let viewModel = ShowProduct.UpdateFavourite.ViewModel(error: response.error)
        viewController?.displayFavourite(viewModel: viewModel)
    }
    
    func presentMonitoring(response: ShowProduct.UpdateMonitoring.Response){
        let viewModel = ShowProduct.UpdateMonitoring.ViewModel(error: response.error)
        viewController?.displayMonitoring(viewModel: viewModel)
    }
}

extension ShowProductPresenter {
    func presentListItem(response: ShowProduct.GetListItem.Response) {
        let viewModel = ShowProduct.GetListItem.ViewModel(listItem: response.listItem)
        viewController?.displayListItem(viewModel: viewModel)
    }
    
    func presentListItemCreated(response: ShowProduct.CreateListItem.Response){
        let viewModel = ShowProduct.CreateListItem.ViewModel(listItem: response.listItem, error: response.error, offline: response.offline)
        viewController?.displayCreatedListItem(viewModel: viewModel)
    }
    
    func presentListItemUpdated(response: ShowProduct.UpdateListItem.Response){
        let viewModel = ShowProduct.UpdateListItem.ViewModel(error: response.error, offline: response.offline)
        viewController?.displayUpdatedListItem(viewModel: viewModel)
    }
}

extension ShowProductPresenter {
    func createDisplayedProduct(product: ProductModel) -> ShowProduct.DisplayedProduct {
        return ShowProduct.DisplayedProduct(
            id: product.id,
            name: product.name,
            price: product.getPrice(),
            oldPrice: product.getOldPrice(),
            promotion: createDisplayedPromotion(promotion: product.promotion),
            largeImage: product.largeImage,
            images: product.images.map{ $0.name },
            description: product.description ?? "",
            features: product.features,
            dimensions: product.dimensions,
            favourite: product.favourite,
            monitoring: product.monitoring,
            avgRating: product.avgRating,
            totalReviewsCount: product.totalReviewsCount,
            storage: product.storage,
            weight: product.weight,
            dietaryInfo: product.dietaryInfo,
            allergenInfo: product.allergenInfo,
            review: product.reviews.first,
            ingredients: product.ingredients,
            
            category: createChildCategory(childCategoryName: product.childCategoryName),
            
            recommended: product.recommended
        )
    }
    
    func createDisplayedPromotion(promotion: PromotionModel?) -> ShowProduct.DisplayedPromotion? {
        return promotion == nil ? nil : ShowProduct.DisplayedPromotion(id: promotion!.id, name: promotion!.name)
    }
    
    func createChildCategory(childCategoryName: String?) -> ShowProduct.DisplayedCategory {
        var categoryName: String = childCategoryName ?? ""
        
        if !categoryName.lowercased().contains("view all"){
            categoryName = "View All " + categoryName
        }
        
        return ShowProduct.DisplayedCategory(name: categoryName)
    }
}
