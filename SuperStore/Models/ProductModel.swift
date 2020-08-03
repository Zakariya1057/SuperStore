//
//  ProductModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ProductModel {
    var id: Int
    var name:String
    var image: String?
    var description: String
    var price:Double
    var location:String?
    
    init(id: Int, name: String,image: String,description: String,price:Double,location:String?) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
        self.price = price
        self.location = location
    }
}
