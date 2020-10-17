//
//  DiscountHistory.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 12/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class DiscountHistory: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var quantity: Int = 0
    @objc dynamic var price: Double = 0
    @objc dynamic var forQuantity: Int = 0
    
    override static func indexedProperties() -> [String] {
        return ["id"]
    }
    
    func getDiscountModel() -> DiscountModel {
        return DiscountModel(id: self.id, name: self.name, quantity: self.quantity, price: self.price, forQuantity: self.forQuantity)
    }
}
