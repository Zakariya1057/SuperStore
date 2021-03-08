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
    var image: String? = nil
    
    @objc dynamic var productID: Int = 1
    
    @objc dynamic var price: Double = 0
    @objc dynamic var totalPrice: Double = 0
    @objc dynamic var quantity: Int = 0
    
    var weight: String? = nil
    
    var promotion: PromotionObject? = nil
    
    @objc dynamic var tickedOff: Bool = false
    
    func getListItemModel() -> ListItemModel {
        return ListItemModel(
            id: id,
            name: name,
            productID: productID,
            image: image,
            price: price,
            totalPrice: totalPrice,
            quantity: quantity,
            weight: weight,
            promotion: promotion?.getPromotionModel(),
            tickedOff: tickedOff
        )
    }
}
