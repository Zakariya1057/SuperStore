//
//  Seeds.swift
//  SuperStoreTests
//
//  Created by Zakariya Mohummed on 24/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

@testable import SuperStore
import XCTest

struct Seeds
{
    struct StoreSeed {
        static let Stores: [StoreModel] = [
            StoreModel(
                id: 1,
                name: "Don Mills and Eglinton",
                logo: "",
                address: "825 Don Mills Rd",
    
                openingHours: [
                    OpeningHourModel(storeID: 1, opensAt: "07:00AM", closesAt: "11:00PM", closedToday: false, dayOfWeek: 0),
                    OpeningHourModel(storeID: 1, opensAt: "07:00AM", closesAt: "11:00PM", closedToday: false, dayOfWeek: 1),
                    OpeningHourModel(storeID: 1, opensAt: "07:00AM", closesAt: "11:00PM", closedToday: false, dayOfWeek: 2),
                    OpeningHourModel(storeID: 1, opensAt: "07:00AM", closesAt: "11:00PM", closedToday: false, dayOfWeek: 3),
                    OpeningHourModel(storeID: 1, opensAt: "07:00AM", closesAt: "11:00PM", closedToday: false, dayOfWeek: 4),
                    OpeningHourModel(storeID: 1, opensAt: "07:00AM", closesAt: "11:00PM", closedToday: false, dayOfWeek: 5),
                    OpeningHourModel(storeID: 1, opensAt: "07:00AM", closesAt: "11:00PM", closedToday: false, dayOfWeek: 6),
                ],
    
                location: LocationModel(
                    storeID: 1,
                    city: "Calgary",
                    addressLine1: "100 Country Village Rd NE",
                    addressLine2: nil,
                    addressLine3: nil,
                    postcode: "",
                    latitude: 51.162093,
                    longitude: -114.069517
                ),
                
                facilities: [
                    "Click & Collect",
                    "Dry Cleaners",
                    "Floral",
                    "Click & Collect",
                    "Garden Centre",
                    "Goodlife Fitness",
                    "Joe Fresh®",
                    "Lottery",
                    "Meals To Go",
                    "Medical Clinic",
                    "Passport Photos",
                    "PC Cooking School",
                    "PC Financial",
                    "PC Financial® ATMs",
                    "PC Financial® Pavilion",
                    "PC Optimum",
                    "Pharmacy",
                    "Prepaid/Long Distance Calling Cards",
                    "The Mobile Shop",
                    "Wine",
                ],
                storeTypeID: 2
            )
        ]
        
        static let DisplayedStores: [Store.DisplayedStore] = [
            Store.DisplayedStore(
                name: "Don Mills and Eglinton",
                logo: "",
                logoImage: UIImage(named: "Canadian SuperStore"),
                address: "825 Don Mills Rd",
                storeTypeID: 2,
                
                openingHours: [
                    Store.DisplayOpeningHour(today: true, hours: "07:00AM - 11:00PM", day: "Monday", dayOfWeek: 0, closedToday: false),
                    Store.DisplayOpeningHour(today: true, hours: "07:00AM - 11:00PM", day: "Tuesday", dayOfWeek: 1, closedToday: false),
                    Store.DisplayOpeningHour(today: true, hours: "07:00AM - 11:00PM", day: "Wednesday", dayOfWeek: 2, closedToday: false),
                    Store.DisplayOpeningHour(today: true, hours: "07:00AM - 11:00PM", day: "Thursday", dayOfWeek: 3, closedToday: false),
                    Store.DisplayOpeningHour(today: true, hours: "07:00AM - 11:00PM", day: "Friday", dayOfWeek: 4, closedToday: false),
                    Store.DisplayOpeningHour(today: true, hours: "07:00AM - 11:00PM", day: "Saturday", dayOfWeek: 5, closedToday: false),
                    Store.DisplayOpeningHour(today: true, hours: "07:00AM - 11:00PM", day: "Sunday", dayOfWeek: 6, closedToday: false),
                ],
                
                facilities: [
                    Store.DisplayFacility(name: "Click & Collect", icon: UIImage()),
                    Store.DisplayFacility(name: "Dry Cleaners", icon: UIImage()),
                    Store.DisplayFacility(name: "Floral", icon: UIImage()),
                    Store.DisplayFacility(name: "Garden Centre", icon: UIImage()),
                    Store.DisplayFacility(name: "Goodlife Fitness", icon: UIImage()),
                    Store.DisplayFacility(name: "Joe Fresh®", icon: UIImage()),
                    Store.DisplayFacility(name: "Meals To Go", icon: UIImage()),
                    Store.DisplayFacility(name: "Pharmacy", icon: UIImage()),
                ]
            )
        ]
    }
}
