//
//  UserData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct UserDataResponse: Decodable {
    var data: UserData
}

struct UserData: Decodable {
    var id: Int
    var name: String
    var token: String
    var email: String
    var send_notifications: Bool
}
