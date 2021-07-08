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
    var badgeNumber: Int? = nil
}

enum SettingType: String {
    case userSettings = "User Settings"
    case deviceStorage = "Device Storage"
    case helpAndFeedback = "Help & Feedback"
    case regionAndSupermarketChain = "Regions & Store"

    
    case store, region
    case login, logout
    
    case name, email, password, notification, delete
    case help, issue, feedback, feature
    
    case imageCache, searchCache
}

enum FeedbackType: String {
    case help
    case issue
    case feedback
    case feature
}
