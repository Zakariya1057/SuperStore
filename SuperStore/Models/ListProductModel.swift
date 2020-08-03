//
//  File.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ListProductModel: ProductModel {
    var quantity: Int = 0
    var ticked: Bool = false
    
    init(id: Int, name: String,image: String,description: String,price:Double,location:String?, quantity: Int,ticked: Bool) {
        super.init(id: id, name: name, image: image, description: description,price:price, location: location)
        self.quantity = quantity
        self.ticked = ticked
    }

}
