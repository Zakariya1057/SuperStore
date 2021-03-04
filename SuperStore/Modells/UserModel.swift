//
//  UserModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct UserModel {
    var id: Int
    var name: String
    var token: String
    var email: String
    var sendNotifications: Bool
}

//struct UserModel {
////    @objc dynamic var id: Int = 1
////    @objc dynamic var name: String = ""
////    @objc dynamic var token: String = ""
////    @objc dynamic var email: String = ""
////    @objc dynamic var identifier: String = ""
////    @objc dynamic var userToken: String = ""
////    @objc dynamic var password: String = ""
////    @objc dynamic var sendNotifications: Bool = true
//
//    var name: String
//    var email: String
//    var sendNotifications: Bool
//}
