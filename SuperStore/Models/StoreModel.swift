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
    var logo: String
    var address: String
    var openingHours: [OpeningHourModel]
    var location: LocationModel
    var facilities: [String]
    var storeTypeID: Int
    
    func getLogoImage() -> UIImage? {
        var image: UIImage? = nil
        
        if(storeTypeID == 1){
            image = UIImage(named: "Asda2")
        } else if(storeTypeID == 2){
            image = UIImage(named: "Canadian SuperStore")
        }

        return image
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

    var latitude: Double
    var longitude: Double
}
