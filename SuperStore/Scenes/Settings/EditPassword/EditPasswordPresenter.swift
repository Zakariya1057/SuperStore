//
//  EditPasswordPresenter.swift
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

protocol EditPasswordPresentationLogic
{
  func presentPasswordUpdated(response: EditPassword.UpdatePassword.Response)
}

class EditPasswordPresenter: EditPasswordPresentationLogic
{
  weak var viewController: EditPasswordDisplayLogic?
  
  // MARK: Do something
  
  func presentPasswordUpdated(response: EditPassword.UpdatePassword.Response)
  {
    let viewModel = EditPassword.UpdatePassword.ViewModel(error: response.error)
    viewController?.displayPasswordUpdated(viewModel: viewModel)
  }
}