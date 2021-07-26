//
//  UserModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import UIKit

struct UserModel {
    var id: Int
    
    var name: String
    var token: String
    var email: String
    
    var regionID: Int
    var supermarketChainID: Int

    var sendNotifications: Bool
}

struct SupermarketChainModel {
    var id: Int
    var name: String
    var type: SupermarketChainType
    var logo: UIImage
    var color: UIColor
}

enum SupermarketChainType: String {
    case realCanadianSuperstore = "Real Canadian Superstore"
    case noFrills = "No Frills"
    case atlanticSuperstore = "Atlantic Superstore"
    case maxi = "Maxi"
}
