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
    struct ProductSeed {
        static let Products: [ProductModel] = [
            ProductModel(
                id: 1,
                storeTypeID: 1,
                name: "",
                smallImage: "",
                largeImage: "",
                images: [],
                description: nil,
                features: nil,
                dimensions: nil,
                price: 1.50,
                oldPrice: nil,
                isOnSale: nil,
                saleEndsAt: nil,
                currency: "£",
                avgRating: 5.0,
                totalReviewsCount: 10,
                promotion: nil,
                storage: nil,
                weight: nil,
                parentCategoryID: 1,
                parentCategoryName: "Fruits",
                childCategoryName: "Apple",
                dietaryInfo: nil,
                allergenInfo: nil,
                brand: nil,
                reviews: [],
                favourite: true,
                monitoring: true,
                ingredients: [],
                recommended: []
            )
        ]
    }
    
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
                    "Bakery",
                    "Click & Collect",
                    "Dentist",
                    "Dietitian",
                    "Dry Cleaners",
                    "Pharmacy",
                    "The Mobile Shop",
                    "Tim Hortons"
                ],
                storeTypeID: 2
            )
        ]
        
        static let DisplayedStores: [Store.DisplayedStore] = [
            Store.DisplayedStore(
                name: "Don Mills and Eglinton",
                logo: "",
                logoImage: UIImage(named: "Canadian SuperStore"),
                address: "100 Country Village Rd NE, Calgary",
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
                    Store.DisplayFacility(name: "Bakery", icon: UIImage()),
                    Store.DisplayFacility(name: "Click & Collect", icon: UIImage()),
                    Store.DisplayFacility(name: "Dentist", icon: UIImage()),
                    Store.DisplayFacility(name: "Dietitian", icon: UIImage()),
                    Store.DisplayFacility(name: "Dry Cleaners", icon: UIImage()),
                    Store.DisplayFacility(name: "Pharmacy", icon: UIImage()),
                    Store.DisplayFacility(name: "The Mobile Shop", icon: UIImage()),
                    Store.DisplayFacility(name: "Tim Hortons", icon: UIImage())
                ]
            )
        ]
    }
}
