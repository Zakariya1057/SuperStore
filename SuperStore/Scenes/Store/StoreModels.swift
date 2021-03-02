//
//  StoreModels.swift
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

enum Store
{
    // MARK: Use cases
    
    enum GetStore
    {
        struct Request
        {
        }
        struct Response
        {
            var store: StoreModel?
            var error: String?
        }
        struct ViewModel
        {
            struct DisplayedStore {
                var name: String
                var logo: String
                var address: String
                
                var openingHours: [DisplayOpeningHour]
                var facilites: DisplayFacilites
            }
            
            struct DisplayOpeningHour {
                var today: Bool
                var hours: String
                var closedToday: Bool
            }

            class DisplayFacilites {
                var carPark: Bool = false
                var babyChanging: Bool = false
                var customerWC: Bool = false
                var heliumBaloons: Bool = false
                var ATM: Bool = false
                var disabledAccess: Bool = false
                var electricVehicleChargingPoint: Bool = false
                var paypoint: Bool = false
                var petrolFillingStation: Bool = false
                var photoCakeMachines: Bool = false
            }
            
            var displayedStore: DisplayedStore?
            var error: String?
        }
    }
}
