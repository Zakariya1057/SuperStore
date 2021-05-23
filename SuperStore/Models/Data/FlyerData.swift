//
//  FlyerData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 23/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct FlyersDataResponse: Decodable {
    var data: [FlyerData]
}

struct FlyerData: Decodable {
    var id: Int
    var name: String
    var week: String?
    var url: String
    var store_id: Int
    var store_type_id: Int
    var valid_from: String
    var valid_to: String
    
    func getFlyerModel() -> FlyerModel {
        let dateWorker = DateWorker()
        
        let validFrom: Date = dateWorker.formatDate(date: valid_from)
        let validTo: Date = dateWorker.formatDate(date: valid_to)
        
        return FlyerModel(
            id: id,
            name: name,
            week: week,
            url: url,
            storeID: store_id,
            storeTypeID: store_type_id,
            validFrom: validFrom,
            validTo: validTo
        )
    }
}
