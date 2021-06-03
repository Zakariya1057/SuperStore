//
//  PromotionGroup.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 07/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct PromotionGroupModel {
    var title: String
    var regionID: Int
    var storeTypeID: Int
    var promotions: [PromotionModel] = []
}
