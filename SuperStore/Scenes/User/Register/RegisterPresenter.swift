//
//  RegisterPresenter.swift
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

protocol RegisterPresentationLogic
{
    func presentUserEmail(response: Register.GetEmail.Response)
    func presentRegisteredUser(response: Register.Register.Response)
    
    func presentRegions(response: Register.GetRegionSupermarketChain.Response)
}

class RegisterPresenter: RegisterPresentationLogic
{
    weak var viewController: RegisterDisplayLogic?

    func presentUserEmail(response: Register.GetEmail.Response)
    {
        let viewModel = Register.GetEmail.ViewModel(email: response.email)
        viewController?.displayUserEmail(viewModel: viewModel)
    }
    
    func presentRegisteredUser(response: Register.Register.Response){
        let viewModel = Register.Register.ViewModel(error: response.error)
        viewController?.displayRegisteredUser(viewModel: viewModel)
    }
}

extension RegisterPresenter {
    func presentRegions(response: Register.GetRegionSupermarketChain.Response) {
        let viewModel = Register.GetRegionSupermarketChain.ViewModel(
            supermarketChainID: response.supermarketChainID,
            regions: response.regions,
            selectedRegion: response.selectedRegion
        )
        
        viewController?.displayRegionSupermarketChain(viewModel: viewModel)
    }
}
