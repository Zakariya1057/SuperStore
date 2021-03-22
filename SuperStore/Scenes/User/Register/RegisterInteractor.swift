//
//  RegisterInteractor.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol RegisterBusinessLogic
{
    func register(request: Register.Register.Request)
    func getEmail(request: Register.GetEmail.Request)
    func getStore(request: Register.GetStore.Request)
}

protocol RegisterDataStore
{
    var email: String? { get set }
}

class RegisterInteractor: RegisterBusinessLogic, RegisterDataStore
{
    var presenter: RegisterPresentationLogic?
    
    var authWorker: UserAuthWorker = UserAuthWorker(userAuth: UserAuthAPI())
    var validationWorker: UserValidationWorker = UserValidationWorker()
    
    var userSession = UserSessionWorker()
    
    var email: String?
    
    func getEmail(request: Register.GetEmail.Request)
    {
        let response = Register.GetEmail.Response(email: email)
        presenter?.presentUserEmail(response: response)
    }
    
    func getStore(request: Register.GetStore.Request){
        let storeTypeID = userSession.getStore()
        
        let response = Register.GetStore.Response(storeTypeID: storeTypeID)
        presenter?.presentStore(response: response)
    }
    
    func register(request: Register.Register.Request){
        let name = request.name
        let email = request.email
        let password = request.password
        let passwordConfirm = request.passwordConfirm
        let storeTypeID = request.storeTypeID
        
        let error = validateForm(name: name, email: email, password: password, passwordConfirm: passwordConfirm)
        
        if error == nil {
            authWorker.register(
                name: name,
                email: email,
                storeTypeID: storeTypeID,
                password: password,
                passwordConfirmation: passwordConfirm,
                identifier: nil,
                userToken: nil,
                completionHandler: registerCompletionHandler
            )
        }
    }
    
}

extension RegisterInteractor {
    
    func validateForm(name: String, email: String, password: String, passwordConfirm: String) -> String? {
        
        let formFields: [UserFormField] = [
            UserFormField(name: "Name", value: name, type: .name),
            UserFormField(name: "Email", value: email, type: .email),
            UserFormField(name: "Password", value: password, type: .password),
            UserFormField(name: "Confirm Password", value: passwordConfirm, type: .password),
            UserPasswordMatch(name: "Password Match", value: password, type: .confirm, repeatValue: passwordConfirm)
        ]
        
        let error = validationWorker.validateFields(formFields)
        
        if let error = error {
            let response = Register.Register.Response(error: error)
            presenter?.presentRegisteredUser(response: response)
            return error
        }
        
        return nil
    }
    
    private func registerCompletionHandler(user: UserModel?, error: String?){
        let response = Register.Register.Response(error: error)
        presenter?.presentRegisteredUser(response: response)
    }
    
    
}
