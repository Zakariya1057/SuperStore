//
//  LocationObject.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 15/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class UserLocationObject: Object {
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var uploaded: Bool = false
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var updatedAt: Date = Date()
    
    func getLocationModel() -> UserLocationModel {
        return UserLocationModel(
            latitude: latitude,
            longitude: longitude,
            uploaded: uploaded,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
