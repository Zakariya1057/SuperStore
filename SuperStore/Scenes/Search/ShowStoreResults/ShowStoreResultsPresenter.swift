//
//  ShowStoreResultsPresenter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowStoreResultsPresentationLogic
{
    func presentStores(response: ShowStoreResults.GetStores.Response)
}

class ShowStoreResultsPresenter: ShowStoreResultsPresentationLogic
{
    weak var viewController: ShowStoreResultsDisplayLogic?

    func presentStores(response: ShowStoreResults.GetStores.Response)
    {
        var displayedStores: [ShowStoreResults.DisplayedStore] = []
        
        let dayOfWeek: Int = getDayOfWeek()
        
        for store in response.stores {
            var openingHour: String = ""
            
            // If single hour given for API loaded results, show first. If all given from locally. Then choose for the given day
            if store.openingHours.count == 1 {
                if let storeHour = store.openingHours.first, storeHour.opensAt != nil {
                    openingHour = "\(storeHour.opensAt!.lowercased()) - \(storeHour.closesAt!.lowercased())"
                }
            } else if store.openingHours.count > 1 {
            
                let storeHour = store.openingHours.first { (hour: OpeningHourModel) -> Bool in
                    hour.dayOfWeek == dayOfWeek
                }
                
                if let storeHour = storeHour {
                    if storeHour.opensAt != nil, storeHour.closesAt != nil {
                        openingHour = "\(storeHour.opensAt!.lowercased()) - \(storeHour.closesAt!.lowercased())"
                    } else {
                        openingHour = "Closed"
                    }
                }
            }
            
            displayedStores.append(
                ShowStoreResults.DisplayedStore(
                    name: store.name,
                    logo: store.logo,
                    logoImage: store.getLogoImage(),
                    address: store.address,
                    openingHour: openingHour
                )
            )
        }
        
        
        let viewModel = ShowStoreResults.GetStores.ViewModel(
            displayedStore: displayedStores,
            stores: response.stores,
            error: response.error,
            offline: response.offline
        )
        
        viewController?.displayStores(viewModel: viewModel)
    }
}

extension ShowStoreResultsPresenter {
    private func getDayOfWeek() -> Int {
        var dayOfWeek = Calendar.current.component(.weekday, from: Date()) - 2
        if dayOfWeek == -1 {
            dayOfWeek = 6
        }
        
        return dayOfWeek
    }
}
