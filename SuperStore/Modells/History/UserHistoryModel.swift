//
//  UserHistoryModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class UserHistoryModel: Codable {
    var id: Int = 1
    var name: String = ""
    var token: String = ""
    var email: String = ""
    var identifier: String = ""
    var userToken: String = ""
    var password: String = ""
    var sendNotifications: Bool = true
}
