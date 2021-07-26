//
//  StorePresenter.swift
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

protocol StorePresentationLogic
{
    func presentStore(response: Store.GetStore.Response)
}

class StorePresenter: StorePresentationLogic
{
    weak var viewController: StoreDisplayLogic?

    func presentStore(response: Store.GetStore.Response)
    {
        
        var displayedStore: Store.DisplayedStore?
        
        if let store = response.store {
            let openingHours = createOpeningHours(openingHour: store.openingHours)
            let facilities = createFacilites(facilites: store.facilities)
            
            displayedStore = Store.DisplayedStore(
                name: store.name,
                logo: "",
                logoImage: store.getLogoImage(),
                address: store.getAddress(),
                supermarketChainID: store.supermarketChainID,
                openingHours: openingHours,
                facilities: facilities
            )
        }
        
        let viewModel = Store.GetStore.ViewModel(displayedStore: displayedStore, error: response.error, offline: response.offline)
        viewController?.displayStore(viewModel: viewModel)
    }
}

extension StorePresenter {
    private func createFacilites(facilites: [String]) -> [Store.DisplayFacility] {
        
        var displayFacilities: [Store.DisplayFacility] = []
        
        for facility in facilites {
            
            if let iconImage = getFacilityIcon(facilites: facility){
                let displayFacility = Store.DisplayFacility(name: facility, icon: iconImage)
                displayFacilities.append(displayFacility)
            }
        }
        
        return displayFacilities
    }
    
    private func createOpeningHours(openingHour: [OpeningHourModel]) -> [Store.DisplayOpeningHour]{
        var displayOpeningHours: [Store.DisplayOpeningHour] = []
        
        let dayOfWeek = getDayOfWeek()
        
        for hour in openingHour {
            var openTimes: String = "Closed"
            
            if hour.opensAt != nil && hour.closesAt != nil{
                openTimes = "\(hour.opensAt!) - \(hour.closesAt!)".lowercased()
            }
            
            let today = dayOfWeek == hour.dayOfWeek
            
            let displayOpeningHour = Store.DisplayOpeningHour(today: today, hours: openTimes, day: getDayName(day: hour.dayOfWeek) ,dayOfWeek: hour.dayOfWeek, closedToday: hour.closedToday)
            displayOpeningHours.append(displayOpeningHour)
        }
        
        return displayOpeningHours
    }
    
    
}

extension StorePresenter {
    private func getDayOfWeek() -> Int {
        var dayOfWeek = Calendar.current.component(.weekday, from: Date()) - 2
        if dayOfWeek == -1 {
            dayOfWeek = 6
        }
        
        return dayOfWeek
    }
    
    func getDayName(day: Int) -> String {
        let days: [Int: String] = [
            0: "Monday",
            1: "Tuesday",
            2: "Wednesday",
            3: "Thursday",
            4: "Friday",
            5: "Saturday",
            6: "Sunday"
        ]
        
        return days[day]!
    }
    
    func getFacilityIcon(facilites: String) -> UIImage? {
        let facilityIcon: [String: UIImage] = [
            "Gas Bar": UIImage(named: "Petrol-Station")!,
            "Dentist": UIImage(named: "Tooth")!,
            "Dietitian": UIImage(named: "Diet")!,
            "Pharmacy": UIImage(named: "Pharmacy")!,
            "Medical Clinic": UIImage(named: "Hospital")!,
            "Optical": UIImage(systemName: "eyeglasses")!,
            "Passport Photos": UIImage(named: "Passport")!,
            "Bakery": UIImage(named: "Bread")!,
            "PC Financial&reg; ATMs": UIImage(named: "ATM")!,
            "Click & Collect": UIImage(named: "Click-Collect")!,
            "Dry Cleaners": UIImage(named: "Dry-Cleaning")!,
            "Floral": UIImage(named: "Flower")!,
            "Joe Fresh®": UIImage(named: "Fashion")!,
            "Salad Bar": UIImage(named: "Salad")!,
            "Seafood": UIImage(named: "Fish")!,
            "Sushi Bar": UIImage(named: "Sushi")!,
            "The Mobile Shop": UIImage(systemName: "phone")!,
            "Tim Hortons": UIImage(named: "Coffee-Cup")!,
            
            "Car Park": UIImage(named: "Car")!,
            "Petrol Filling Station": UIImage(named: "Petrol-Station")!,
            "Paypoint": UIImage(named: "PayPoint")!,
            "Cash Machine": UIImage(named: "ATM")!,
            "Baby Changing": UIImage(named: "Diaper")!,
            "Disabled Facilities": UIImage(named: "Disabled")!,
            "Customer WC": UIImage(named: "WC")!,
            "Opticians": UIImage(systemName: "eyeglasses")!,
            "Costa Coffee": UIImage(named: "Coffee-Cup")!,
            "Helium Balloons": UIImage(named: "Balloon")!,
            "Photo Cake Machines": UIImage(named: "Birthday-Cake")!,
            "Electric Vehicle Charging Point": UIImage(named: "Electric-Charging")!
        ]
        
        return facilityIcon[facilites]
    }
    
    
}
