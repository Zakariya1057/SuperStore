//
//  SendEmailPresenter.swift
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

protocol SendEmailPresentationLogic
{
    func presentEmail(response: SendEmail.GetEmail.Response)
    func presentEmailSent(response: SendEmail.SendEmail.Response)
}

class SendEmailPresenter: SendEmailPresentationLogic
{
    weak var viewController: SendEmailDisplayLogic?
    
    func presentEmailSent(response: SendEmail.SendEmail.Response)
    {
        let viewModel = SendEmail.SendEmail.ViewModel(error: response.error)
        viewController?.displayEmailSent(viewModel: viewModel)
    }
    
    func presentEmail(response: SendEmail.GetEmail.Response)
    {
        let viewModel = SendEmail.GetEmail.ViewModel(email: response.email)
        viewController?.displayEmail(viewModel: viewModel)
    }
}