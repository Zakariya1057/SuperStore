//
//  FlyerObject.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 23/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class FlyerObject: Object {
    @objc dynamic var id: Int = 1
    
    @objc dynamic var name: String = ""
    @objc dynamic var week: String? = nil
    
    @objc dynamic var url: String = ""
    
    @objc dynamic var storeID: Int = 0
    @objc dynamic var storeTypeID: Int = 0
    
    var products = List<ProductObject>()
    
    @objc dynamic var validFrom: Date = Date()
    @objc dynamic var validTo: Date = Date()
    
    func getFlyerModel() -> FlyerModel {
        return FlyerModel(
            id: id,
            name: name,
            week: week,
            url: url,
            storeID: storeID,
            storeTypeID: storeTypeID,
            validFrom: validFrom,
            validTo: validTo
        )
    }
}
