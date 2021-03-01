//
//  ShowReviewsPresenter.swift
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

protocol ShowReviewsPresentationLogic
{
  func presentReviews(response: ShowReviews.GetReviews.Response)
}

class ShowReviewsPresenter: ShowReviewsPresentationLogic
{
  weak var viewController: ShowReviewsDisplayLogic?
  
  // MARK: Do something
  
  func presentReviews(response: ShowReviews.GetReviews.Response)
  {
    let viewModel = ShowReviews.GetReviews.ViewModel(reviews: response.reviews, error: response.error)
    viewController?.displayReviews(viewModel: viewModel)
  }
}