//
//  ProductModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ProductModel: ProductItemModel {
    var id: Int
    var description: String?
    var favourite: Bool? = nil

    var avg_rating: Double = 0
    var total_reviews_count: Int = 0

    var parent_category_id: Int?
    var parent_category_name: String?

    init(id: Int, name: String, image: String, quantity: Int, product_id: Int, price: Double, weight: String?, discount: DiscountModel?, description: String?, favourite: Bool?, avg_rating: Double?, total_reviews_count: Int?, parent_category_id: Int?, parent_category_name: String?) {
        self.id = id
        self.description = description
        self.favourite = favourite ?? false
        self.avg_rating = avg_rating ?? 0
        self.total_reviews_count = total_reviews_count ?? 0
        
        self.parent_category_id = parent_category_id
        self.parent_category_name = parent_category_name
        
        super.init(name: name, image: image, quantity: quantity, product_id: product_id, price: price, weight: weight, discount: discount)
    }
    
    func getRealmObject() -> ProductHistory {
        let product = ProductHistory()
        product.id = self.product_id
        product.name = self.name
        product.image = self.image
        product.product_description = self.description
        product.quantity = self.quantity
        product.weight = self.weight
        product.price = self.price
        product.avg_rating = self.avg_rating
        product.total_reviews_count = self.total_reviews_count
        product.favourite = self.favourite!

        product.parent_category_id = self.parent_category_id ?? 0
        product.parent_category_name = self.parent_category_name

        product.discount = self.discount?.getRealmObject()

        return product
    }
}
