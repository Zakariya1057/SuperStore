//
//  AuthenticationWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class UserWorker {
    var userAuth: UserAuthProtocol
    var userStore: UserStoreProtocol
    
    init(userAuth: UserAuthProtocol) {
        self.userAuth = userAuth
        self.userStore = UserStore()
    }
    
    func login(email: String, password: String, notificationToken: String?, completionHandler: @escaping (_ user: UserLoginModel?, _ error: String?) -> Void ){
        userAuth.login(email: email, password: password, notificationToken: notificationToken) { (user: UserLoginModel?, error: String?) in
            // Save User Stuff Like Token For Sending Request
            completionHandler(user, error)
        }
    }
}

protocol UserAuthProtocol {
    // Login takes email and password. Callback used for when response received
    // Completion Can return error (login failed) or user data like tokens and such
    func login(email: String, password: String, notificationToken: String?, completionHandler: @escaping (UserLoginModel?, String?) -> Void )
}


protocol UserStoreProtocol {
    
}
