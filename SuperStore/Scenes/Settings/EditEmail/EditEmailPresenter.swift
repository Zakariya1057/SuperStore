//
//  EditEmailPresenter.swift
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

protocol EditEmailPresentationLogic
{
    func presentEmail(response: EditEmail.GetEmail.Response)
    func presentEmailUpdated(response: EditEmail.UpdateEmail.Response)
}

class EditEmailPresenter: EditEmailPresentationLogic
{
    weak var viewController: EditEmailDisplayLogic?
    
    // MARK: Do something
    
    func presentEmail(response: EditEmail.GetEmail.Response)
    {
        let viewModel = EditEmail.GetEmail.ViewModel(email: response.email)
        viewController?.displayEmail(viewModel: viewModel)
    }
    
    func presentEmailUpdated(response: EditEmail.UpdateEmail.Response)
    {
        let viewModel = EditEmail.UpdateEmail.ViewModel(error: response.error)
        viewController?.displayEmailUpdated(viewModel: viewModel)
    }
}
