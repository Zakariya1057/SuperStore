//
//  UserSessionWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class UserSessionWorker {
    static var notificationToken: String?
    
    var userStore: UserStoreProtocol = UserRealmStore()
    
    func getUserToken() -> String? {
        return userStore.retrieveToken()
    }
    
    func getUserNotificationToken() -> String? {
        return type(of: self).notificationToken
    }
    
    func logInUser(user: UserLoginModel){
        userStore.saveLoggedInUser(user: user)
    }
    
    func isLoggedIn() -> Bool {
        return getUserToken() != nil
    }
}

protocol UserStoreProtocol {
    func retrieveToken() -> String?
    func saveLoggedInUser(user: UserLoginModel)
}
