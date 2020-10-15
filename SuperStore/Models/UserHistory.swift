//
//  UserHistory.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 13/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class UserHistory: Object, Codable {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var token: String = ""
    @objc dynamic var email: String = ""
    
    func getUserModel() -> UserModel {
        return UserModel(id: self.id, name: self.name, token: self.token, email: self.email)
    }
}
