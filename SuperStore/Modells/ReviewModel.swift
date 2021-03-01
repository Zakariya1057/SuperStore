//
//  ReviewModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct ReviewModel {
    var id: Int
    var text: String
    var title: String
    var rating: Int
    var name: String
    var productID: Int
    var userID: Int
    var updatedAt: Date
    var createdAt: Date
}
