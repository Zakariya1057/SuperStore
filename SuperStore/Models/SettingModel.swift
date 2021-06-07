//
//  SettingModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 07/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct SettingModel {
    var name: String
    var value: String? = nil
    var on: Bool = false
    var type: SettingType
}

enum SettingType: String {
    case name, email, store, region, password, notification
    case helpFeedback, help, reportIssue, feedback, feature
    case logout, login
    case delete
}
