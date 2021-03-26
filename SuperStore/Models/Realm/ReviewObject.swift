//
//  ReviewObject.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ReviewObject: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var text: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var rating: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var productID: Int = 1
    @objc dynamic var userID: Int = 1
    
    @objc dynamic var updatedAt: Date = Date()
    @objc dynamic var createdAt: Date = Date()
    
    func getReviewModel() -> ReviewModel {
        return ReviewModel(
            id: id,
            text: text,
            title: title,
            rating: rating,
            name: name,
            productID: productID,
            userID: userID,
            updatedAt: createdAt,
            createdAt: updatedAt
        )
    }
    
    
    override static func primaryKey() -> String? {
         return "id"
     }
}
