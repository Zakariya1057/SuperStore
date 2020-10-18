//
//  DiscountModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 17/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class DiscountModel {
    var id: Int
    var name: String
    var quantity: Int
    var price: Double?
    var forQuantity: Int?
    
    init(id: Int, name: String, quantity: Int, price: Double?,forQuantity: Int? ) {
        self.quantity = quantity
        self.price = price
        self.forQuantity = forQuantity
        self.name = name
        self.id = id
    }
    
    func getRealmObject() -> DiscountHistory {
        
        let realm = try! Realm()
        
        var discount = realm.objects(DiscountHistory.self).filter("id = \(self.id)").first
        
        if(discount == nil){
            discount = DiscountHistory()
            discount!.id = self.id
            discount!.name = self.name
            discount!.quantity = self.quantity
            discount!.forQuantity = self.forQuantity ?? 0
            discount!.price = self.price ?? 0
        }
        
        return discount!
        
    }
}
