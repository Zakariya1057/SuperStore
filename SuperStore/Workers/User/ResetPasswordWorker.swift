//
//  PasswordResetWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ResetPasswordWorker {
    var passwordReset: ResetPasswordProtocol
    var userSession: UserSessionWorker
    
    init(passwordReset: ResetPasswordProtocol) {
        self.passwordReset = passwordReset
        self.userSession = UserSessionWorker()
    }
    
    func sendEmail(email: String, completionHandler: @escaping (_ error: String?) -> Void ){
        passwordReset.sendEmail(email: email, completionHandler: completionHandler)
    }
    
    func verifyCode(email: String, code: String, completionHandler: @escaping ( _ error: String?) -> Void){
        passwordReset.verifyCode(email: email, code: code, completionHandler: completionHandler)
    }
    
    func newPassword(email: String, code: String, password: String, passwordConfirmation: String, completionHandler: @escaping (_ user: UserModel?, _ error: String?) -> Void){
        
        let notificationToken = userSession.getUserNotificationToken() ?? ""
        
        passwordReset.newPassword(email: email, code: code, password: password, passwordConfirmation: passwordConfirmation, notificationToken: notificationToken) { (user: UserModel?, error: String?) in
            if user != nil {
                self.userSession.logInUser(user: user!)
            }
            
            completionHandler(user, error)
        }
    }
}

protocol ResetPasswordProtocol {
    func sendEmail(email: String, completionHandler: @escaping (String?) -> Void)
    
    func verifyCode(email: String, code: String, completionHandler: @escaping (String?) -> Void)
    
    func newPassword(
        email: String, code: String, password: String,
        passwordConfirmation: String,notificationToken: String,
        completionHandler: @escaping ( UserModel?, String?) -> Void
    )
}

