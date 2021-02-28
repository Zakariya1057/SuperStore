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
  func presentSomething(response: EditReview.Something.Response)
}

class EditReviewPresenter: EditReviewPresentationLogic
{
  weak var viewController: EditReviewDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: EditReview.Something.Response)
  {
    let viewModel = EditReview.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
