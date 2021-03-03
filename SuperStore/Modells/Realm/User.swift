//
//  UserHistory.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object, Codable {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var token: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var identifier: String = ""
    @objc dynamic var userToken: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var sendNotifications: Bool = true
}
