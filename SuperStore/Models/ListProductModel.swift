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
    
    init(id: Int, name: String,image: String,description: String,price:Double,location:String?,avg_rating: Double?, total_reviews_count: Int?, quantity: Int,ticked: Bool) {
        super.init(id: id, name: name, image: image, description: description,price:price, location: location,avg_rating: avg_rating, total_reviews_count: total_reviews_count)
        self.quantity = quantity
        self.ticked = ticked
    }

}
