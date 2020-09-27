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
        requestHandler.postRequest(url: urlString, data: userData, complete: proccessUpdate, error: processError)
    }
    
    
    func processResults(_ data:Data){
        
        do {
            
            print("Processing Results")

            let decoder = JSONDecoder()
            let decodedUserData = try decoder.decode(UserLoginDataResponse.self, from: data)
            let token = decodedUserData.data.token

            // Store user token, for subsequent requests
            
            DispatchQueue.main.async {
                self.delegate?.contentLoaded()
            }
        
        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func proccessUpdate(_ data:Data){
        DispatchQueue.main.async {
            self.delegate?.contentLoaded()
        }
    }
    
    func processError(_ message:String){
        self.delegate?.errorHandler(message)
    }
}
