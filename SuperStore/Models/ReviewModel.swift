//
//  ReviewModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 29/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct ReviewModel {
    var id: Int
    var text: String
    var title: String
    var rating: Int
    var name: String
    var product_id: Int
    var user_id: Int
    var updated_at: Date
    var created_at: Date
    
    func getRealmObject() -> ReviewHistory {
        let review = ReviewHistory()
        review.id = self.id
        review.text = self.text
        review.title = self.title
        review.name = self.name
        review.rating = self.rating
        review.product_id = self.product_id
        review.user_id = self.user_id
        review.updated_at = self.updated_at
        review.created_at = self.created_at
        return review
    }
}
