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
    
    let userSession = UserSession()
    
    let requestHandler = RequestHandler()
    
    func requestRegister(name: String, email: String, password: String, passwordConfirmation: String){
        let registerPath = K.Request.User.Register
        let urlString = "\(K.Host)/\(registerPath)"
        requestHandler.postRequest(url: urlString, data: ["name": name, "password": password, "password_confirmation": passwordConfirmation, "email": email ], complete: processResults, error: processError)
    }
    
    func requestLogin(email: String, password: String){
        let loginPath = K.Request.User.Login
        let urlString = "\(K.Host)/\(loginPath)"
        requestHandler.postRequest(url: urlString, data: ["email": email, "password": password], complete: processResults, error: processError)
    }
    
    func requestUpdate(userData: [String: String]){
        let updatePath = K.Request.User.Update
        let urlString = "\(K.Host)/\(updatePath)"
        requestHandler.postRequest(url: urlString, data: userData, complete: proccessReturn, error: processError)
    }
    
    func requestLogout(){
        let logOutPath = K.Request.User.LogOut
        let urlString = "\(K.Host)/\(logOutPath)"
        requestHandler.postRequest(url: urlString, data: ["": ""], complete: { _ in }, error: processError)
    }
    
    func requestResetCode(email: String){
        let logOutPath = K.Request.User.SendResetCode
        let urlString = "\(K.Host)/\(logOutPath)"
        requestHandler.postRequest(url: urlString, data: ["email": email], complete: proccessReturn, error: processError)
    }
    
    func requestValidateCode(email: String, code: String){
        let logOutPath = K.Request.User.ValidateResetCode
        let urlString = "\(K.Host)/\(logOutPath)"
        requestHandler.postRequest(url: urlString, data: ["email": email,"code": code], complete: proccessReturn, error: processError)
    }
    
    func requestResetPassword(userData: [String: String]){
        let logOutPath = K.Request.User.ResetPassword
        let urlString = "\(K.Host)/\(logOutPath)"
        requestHandler.postRequest(url: urlString, data: userData, complete: processResults, error: processError)
    }
    
    func processResults(_ data:Data){
        
        do {
            
            print("Processing Results")

            let decoder = JSONDecoder()
            let decodedUserData = try decoder.decode(UserLoginDataResponse.self, from: data)
            
            let userData:UserData = decodedUserData.data
            userSession.setLoggedIn(userData)
            
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
    
    func processError(_ message:String){
        self.delegate?.errorHandler(message)
    }
}
