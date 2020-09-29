//
//  UserData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct UserLoginDataResponse:Decodable {
    var data: UserData
}

struct UserData: Codable {
    var name: String
    var token: String
    var email: String
}