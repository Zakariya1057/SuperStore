//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol UserDelegate {
    func contentLoaded()
    func errorHandler(_ message:String)
}

struct UserHandler {
    
    var delegate: UserDelegate?
    
    var userSession = UserSession()
    
    let requestHandler = RequestHandler()
    
    func requestRegister(name: String, email: String, password: String, passwordConfirmation: String){
        let urlString = "\(K.Host)/\(K.Request.User.Register)"
        requestHandler.postRequest(url: urlString, data: ["name": name, "password": password, "password_confirmation": passwordConfirmation, "email": email ], complete: processResults, error: processError, logOutUser: logOutUser )
    }
    
    func requestLogin(email: String, password: String){
        let urlString = "\(K.Host)/\(K.Request.User.Login)"
        requestHandler.postRequest(url: urlString, data: ["email": email, "password": password], complete: processResults, error: processError, logOutUser: logOutUser)
    }
    
    func requestUpdate(userData: [String: String]){
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
        requestHandler.postRequest(url: urlString, data: ["": ""], complete: { _ in }, error: processError, logOutUser: logOutUser)
        userSession.logOut()
    }
    
    func requestResetCode(email: String){
        let logOutPath = K.Request.User.SendResetCode
        let urlString = "\(K.Host)/\(logOutPath)"
        requestHandler.postRequest(url: urlString, data: ["email": email], complete: proccessReturn, error: processError, logOutUser: logOutUser)
    }
    
    func requestValidateCode(email: String, code: String){
        let logOutPath = K.Request.User.ValidateResetCode
        let urlString = "\(K.Host)/\(logOutPath)"
        requestHandler.postRequest(url: urlString, data: ["email": email,"code": code], complete: proccessReturn, error: processError, logOutUser: logOutUser)
    }
    
    func requestResetPassword(userData: [String: String]){
        let logOutPath = K.Request.User.ResetPassword
        let urlString = "\(K.Host)/\(logOutPath)"
        requestHandler.postRequest(url: urlString, data: userData, complete: processResults, error: processError, logOutUser: logOutUser)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            print("Processing Results")

            let decoder = JSONDecoder()
            let decodedUserData = try decoder.decode(UserLoginDataResponse.self, from: data)
            
            let userData:UserData = decodedUserData.data
            
            let user = UserHistory()
            user.id = userData.id
            user.name = userData.name
            user.email = userData.email
            user.token = userData.token
            
            userSession.setLoggedIn(user)
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded()
            }
        
        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func proccessReturn(_ data:Data){
        DispatchQueue.main.async {
            self.delegate?.contentLoaded()
        }
    }
    
    func logOutUser(){

    }
    
    func processError(_ message:String){
        self.delegate?.errorHandler(message)
    }
}
