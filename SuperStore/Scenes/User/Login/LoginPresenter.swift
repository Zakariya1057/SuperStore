//
//  LoginPresenter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LoginPresentationLogic
{
    func presentLogin(response: Login.Login.Response)
    
}

class LoginPresenter: LoginPresentationLogic
{
    weak var viewController: LoginDisplayLogic?

    func presentLogin(response: Login.Login.Response)
    {
        let viewModel = Login.Login.ViewModel(error: response.error)
        viewController?.displayLoggedInUser(viewModel: viewModel)
    }
}
