//
//  ShowFlyerPresenter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 23/05/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowFlyerPresentationLogic
{
    func presentFlyer(response: ShowFlyer.GetFlyer.Response)
}

class ShowFlyerPresenter: ShowFlyerPresentationLogic
{
    weak var viewController: ShowFlyerDisplayLogic?
    
    func presentFlyer(response: ShowFlyer.GetFlyer.Response)
    {
        let flyer = response.flyer
        
        let dateWorker = DateWorker()
        
        let validFrom = dateWorker.getDayAndMonth(date: flyer.validFrom)
        let validTo = dateWorker.getDayAndMonth(date: flyer.validTo)
        
        let validDate = "\(validFrom) - \(validTo)"
        
        let displayedFlyer = ShowFlyer.GetFlyer.ViewModel.DisplayedFlyer(
            name: flyer.name,
            url: flyer.url,
            validDate: validDate
        )
        
        viewController?.displayFlyer(viewModel: displayedFlyer)
    }
}
