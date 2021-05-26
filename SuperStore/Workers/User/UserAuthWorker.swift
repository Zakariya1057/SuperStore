//
//  AuthenticationWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class UserAuthWorker {
    private var userAuth: UserAuthProtocol
    private var userSession: UserSessionWorker
    
    init(userAuth: UserAuthProtocol) {
        self.userAuth = userAuth
        self.userSession = UserSessionWorker()
    }
    
    func login(
        email: String, password: String,
        completionHandler: @escaping (_ user: UserModel?, _ error: String?) -> Void ){
        
        let notificationToken = userSession.getUserNotificationToken()
        
        userAuth.login(email: email, password: password, notificationToken: notificationToken) { (user: UserModel?, error: String?) in
            if user != nil {
                self.userSession.logInUser(user: user!)
            }
            
            completionHandler(user, error)
        }
    }
    
    func register(
        name: String,
        email: String,
        storeTypeID: Int,
        password: String,
        passwordConfirmation: String,
        identifier: String?, userToken: String?,
        completionHandler: @escaping (_ user: UserModel?, _ error: String?) -> Void ){
        
        let notificationToken = userSession.getUserNotificationToken()
        
        userAuth.register(
            name: name,
            email: email,
            
            password: password,
            passwordConfirmation: passwordConfirmation,
            
            notificationToken: notificationToken,
            identifier: identifier,
            userToken: userToken,
            
            regionID: 1,
            storeTypeID: storeTypeID
        ) {  (user: UserModel?, error: String?) in
            
            if user != nil {
                self.userSession.logInUser(user: user!)
            }
            
            completionHandler(user, error)
        }
        
    }
}

protocol UserAuthProtocol {
    func login(
        email: String, password: String, notificationToken: String?,
        completionHandler: @escaping (UserModel?, String?) -> Void
    )
    
    func register(
        name: String,
        email: String,
        
        password: String,
        passwordConfirmation: String,
        
        notificationToken: String?,
        
        identifier: String?,
        userToken: String?,
        
        regionID: Int,
        storeTypeID: Int,
        completionHandler: @escaping (UserModel?, String?) -> Void
    )
}

