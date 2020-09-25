//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol UserDelegate {
    func contentLoaded(suggestions: [SearchModel])
//    func errorHandler(_ message:String)
}

struct UserHandler {
    
    var delegate: UserDelegate?
    
    let requestHandler = RequestHandler()
    
    func requestRegister(name: String, email: String, password: String, passwordConfirmation: String){
        let registerPath = K.Request.User.Register
        let urlString = "\(K.Host)/\(registerPath)"
        requestHandler.postRequest(url: urlString, data: ["name": name, "password": password, "password_confirmation": passwordConfirmation, "email": email ], complete: { _ in }, error: processError)
    }
    
    func requestLogin(email: String, password: String){
        let loginPath = K.Request.User.Login
        let urlString = "\(K.Host)/\(loginPath)"
        requestHandler.postRequest(url: urlString, data: ["email": email, "password": password], complete: { _ in }, error: processError)
    }
    
    func requestUpdate(userData: [String: String]){
        let updatePath = K.Request.User.Update
        let urlString = "\(K.Host)/\(updatePath)"
        requestHandler.postRequest(url: urlString, data: userData, complete: { _ in }, error: processError)
    }
    
    func processError(_ message:String){
//        self.delegate?.errorHandler(message)
    }
}
