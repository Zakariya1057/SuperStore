//
//  StoreModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import UIKit

struct StoreModel {
    var id: Int
    var name: String
    var logo: String? = nil
    var address: String
    var openingHours: [OpeningHourModel]
    var location: LocationModel
    var facilities: [String]
    var supermarketChainID: Int
    
    func getLogoImage() -> UIImage? {
        let supermarketChainWorker = SupermarketChainWorker()
        return supermarketChainWorker.getSupermarketChainLogo(supermarketChainID: supermarketChainID)
    }
    
    func getAddress() -> String {
        let addressList = [location.addressLine1, location.addressLine2, location.addressLine3, location.city ]
        return addressList.compactMap { $0 }.joined(separator: ", ")
    }
}

struct OpeningHourModel {
    let storeID: Int

    let opensAt:String?
    let closesAt:String?
    let closedToday:Bool
    let dayOfWeek:Int
}

struct LocationModel {
    let storeID: Int

    let city: String
    let addressLine1: String
    let addressLine2: String?
    let addressLine3: String?
    let postcode: String

    var latitude: Double?
    var longitude: Double?
}
