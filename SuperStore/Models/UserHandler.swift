//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Alamofire

protocol UserDelegate {
    func contentLoaded()
    func errorHandler(_ message:String)
    func logOutUser()
}

struct UserHandler {
    
    var delegate: UserDelegate?
    
    var userSession = UserSession()
    
    let requestHandler = RequestHandler()
    
    var notificationToken: String {
        return UserSession.sharedInstance.notificationToken ?? " "
    }
    
    func requestRegister(name: String, email: String, password: String, passwordConfirmation: String, identifier: String = "", userToken: String = ""){
        let urlString = "\(K.Host)/\(K.Request.User.Register)"
        requestHandler.postRequest(url: urlString, data: ["name": name, "password": password, "password_confirmation": passwordConfirmation, "email": email, "identifier": identifier, "user_token": userToken, "notification_token": notificationToken ], complete: processResults, error: processError, logOutUser: logOutUser )
    }
    
    func requestLogin(email: String, password: String){
        let urlString = "\(K.Host)/\(K.Request.User.Login)"
        requestHandler.postRequest(url: urlString, data: ["email": email, "password": password, "notification_token": notificationToken], complete: processResults, error: processError, logOutUser: logOutUser)
    }
    
    func requestUpdate(userData: Parameters){
        let urlString = "\(K.Host)/\(K.Request.User.Update)"
        requestHandler.postRequest(url: urlString, data: userData, complete: proccessReturn, error: processError, logOutUser: logOutUser)
    }
    
    func requestDelete(userData: [String: String]){
        let urlString = "\(K.Host)/\(K.Request.User.Delete)"
        requestHandler.postRequest(url: urlString, data: userData, complete: proccessReturn, error: processError, logOutUser: logOutUser)
    }
    
    func requestLogout(){
        let logOutPath = K.Request.User.LogOut
        let urlString = "\(K.Host)/\(logOutPath)"
        requestHandler.postRequest(url: urlString, data: ["": ""], complete: { _ in self.delegate?.contentLoaded() }, error: processError, logOutUser: logOutUser)
        
        if userSession.viewController != nil {
            userSession.logOut()
        }
    }


    func requestResetCode(email: String){
        requestHandler.postRequest(url: "\(K.Host)/\(K.Request.User.SendResetCode)", data: ["email": email], complete: proccessReturn, error: processError, logOutUser: logOutUser)
    }
    
    func requestValidateCode(email: String, code: String){
        requestHandler.postRequest(url: "\(K.Host)/\(K.Request.User.ValidateResetCode)", data: ["email": email,"code": code], complete: proccessReturn, error: processError, logOutUser: logOutUser)
    }
    
    func requestResetPassword(userData: [String: String]){
        requestHandler.postRequest(url: "\(K.Host)/\(K.Request.User.ResetPassword)", data: userData, complete: processResults, error: processError, logOutUser: logOutUser)
    }
    
    func processResults(_ data:Data){
        
        do {

            let decoder = JSONDecoder()
            let decodedUserData = try decoder.decode(UserLoginDataResponse.self, from: data)
            
            let userData:UserData = decodedUserData.data
            
            let user = UserHistory()
            user.id = userData.id
            user.name = userData.name
            user.email = userData.email
            user.token = userData.token
            user.send_notifications = userData.send_notifications
            
            userSession.setLoggedIn(user)
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded()
            }
        
        } catch {
            processError("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func proccessReturn(_ data:Data){
        DispatchQueue.main.async {
            self.delegate?.contentLoaded()
        }
    }
    
    func logOutUser(){
        print("Delete/Logout Unauth. Log User Out")
        self.delegate?.logOutUser()
    }
    
    func processError(_ message:String){
        print(message)
        self.delegate?.errorHandler(message)
    }
}
