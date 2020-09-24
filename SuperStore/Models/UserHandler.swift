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
    
    func requestRegister(name: String, password: String, passwordConfirmation: String, email : String){
        let hostURL = K.Host
        let registerPath = K.Request.User.Register
        let urlString = "\(hostURL)/\(registerPath)"
        requestHandler.postRequest(url: urlString, data: ["name": name, "password": password, "password_confirmation": passwordConfirmation, "email": email ], complete: { _ in }, error: processError)
    }
    
    func processError(_ message:String){
//        self.delegate?.errorHandler(message)
    }
}
