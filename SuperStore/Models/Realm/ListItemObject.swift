//
//  ListItemObject.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ListItemObject: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var image: String? = nil
    
    @objc dynamic var productID: Int = 1
    @objc dynamic var listID: Int = 1
    
    @objc dynamic var price: Double = 0
    @objc dynamic var totalPrice: Double = 0
    @objc dynamic var currency: String = ""
    
    @objc dynamic var quantity: Int = 0
    
    @objc dynamic var weight: String? = nil
    
    @objc dynamic var promotion: PromotionObject? = nil
    
    @objc dynamic var tickedOff: Bool = false
    
    func getListItemModel() -> ListItemModel {
        return ListItemModel(
            id: id,
            name: name,
            productID: productID,
            image: image,
            price: price,
            currency: currency,
            totalPrice: totalPrice,
            quantity: quantity,
            weight: weight,
            promotion: promotion?.getPromotionModel(),
            tickedOff: tickedOff
        )
    }
}
