//
//  NewPasswordPresenter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol NewPasswordPresentationLogic
{
  func presentNewPassword(response: NewPassword.NewPassword.Response)
}

class NewPasswordPresenter: NewPasswordPresentationLogic
{
  weak var viewController: NewPasswordDisplayLogic?
  
  // MARK: Do something
  
  func presentNewPassword(response: NewPassword.NewPassword.Response)
  {
    let viewModel = NewPassword.NewPassword.ViewModel(error: response.error)
    viewController?.displayNewPassword(viewModel: viewModel)
  }
}
