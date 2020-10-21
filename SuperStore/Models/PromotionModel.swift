//
//  DiscountModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 17/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class PromotionModel {
    var id: Int
    var name: String
    var quantity: Int
    var price: Double?
    var forQuantity: Int?
    var products:[ProductModel]
    var expires: Bool = false
    var startsAt: Date? = nil
    var endsAt: Date? = nil
    
    init(id: Int, name: String, quantity: Int, price: Double?,forQuantity: Int?, products: [ProductModel] = [],expires: Bool = false, startsAt: Date? = nil, endsAt: Date? = nil) {
        self.quantity = quantity
        self.price = price
        self.forQuantity = forQuantity
        self.name = name
        self.id = id
        self.products = products
        self.expires = expires
        self.startsAt = startsAt
        self.endsAt = endsAt
    }
    
    func getRealmObject() -> PromotionHistory {
        
        let realm = try! Realm()
        
        var promotion = realm.objects(PromotionHistory.self).filter("id = \(self.id)").first
        
        if(promotion == nil){
            promotion = PromotionHistory()
            promotion!.id = self.id
            promotion!.name = self.name
            promotion!.quantity = self.quantity
            promotion!.forQuantity = self.forQuantity ?? 0
            promotion!.price = self.price ?? 0
            promotion!.expires = self.expires
            promotion!.startsAt = self.startsAt
            promotion!.endsAt = self.endsAt
            
            self.products.forEach({ promotion!.products.append( $0.id) })
        }
        
        return promotion!
        
    }
}
