//
//  EditReviewPresenter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EditReviewPresentationLogic
{
    func presentReview(response: EditReview.GetReview.Response)
    func presentReviewCreated(response: EditReview.CreateReview.Response)
    func presentReviewUpdated(response: EditReview.UpdateReview.Response)
    func presentReviewDeleted(response: EditReview.DeleteReview.Response)
}

class EditReviewPresenter: EditReviewPresentationLogic
{
    
    weak var viewController: EditReviewDisplayLogic?
    
    func presentReview(response: EditReview.GetReview.Response)
    {
        var displayedReview: EditReview.GetReview.ViewModel.DisplayedReview?
        
        if let review = response.review, let product = response.product {
            displayedReview = EditReview.GetReview.ViewModel.DisplayedReview(
                id: review.id, image: product.largeImage,
                productName: product.name, text: review.text,
                title: review.title, rating: Double(review.rating), name: review.name
            )
        }
        
        let viewModel = EditReview.GetReview.ViewModel(displayedReview: displayedReview, error: response.error)
        viewController?.displayReview(viewModel: viewModel)
    }
    
    func presentReviewCreated(response: EditReview.CreateReview.Response) {
        let viewModel = EditReview.CreateReview.ViewModel(error: response.error)
        viewController?.displayReviewCreated(viewModel: viewModel)
    }
    
    func presentReviewUpdated(response: EditReview.UpdateReview.Response) {
        let viewModel = EditReview.UpdateReview.ViewModel(error: response.error)
        viewController?.displayReviewUpdated(viewModel: viewModel)
    }
    
    func presentReviewDeleted(response: EditReview.DeleteReview.Response) {
        let viewModel = EditReview.DeleteReview.ViewModel(error: response.error)
        viewController?.displayReviewDeleted(viewModel: viewModel)
    }
}