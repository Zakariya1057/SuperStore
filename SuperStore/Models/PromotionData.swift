//
//  PromotionData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 30/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct PromotionDataResponse: Decodable {
    var data: PromotionData
}

struct PromotionData: Decodable {
    var id: Int
    var name: String
    var ends_at: String?
    let products: [ProductData]?
}
