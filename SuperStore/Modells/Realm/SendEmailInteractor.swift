//
//  SendEmailInteractor.swift
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

protocol SendEmailBusinessLogic
{
    func sendEmail(request: SendEmail.SendEmail.Request)
    func getEmail(request: SendEmail.GetEmail.Request)
}

protocol SendEmailDataStore
{
    var email: String? { get set }
}

class SendEmailInteractor: SendEmailBusinessLogic, SendEmailDataStore
{
    var presenter: SendEmailPresentationLogic?
    var resetWorker: ResetPasswordWorker = ResetPasswordWorker(passwordReset: ResetPasswordAPI())
    
    var validationWorker: UserValidationWorker = UserValidationWorker()
    var email: String?
    
    func sendEmail(request: SendEmail.SendEmail.Request)
    {
        let email = request.email
        
        let error = validateForm(email: email)
        
        if error == nil {
            self.email = email
            resetWorker.sendEmail(email: email) { (error: String?) in
                let response = SendEmail.SendEmail.Response(error: error)
                self.presenter?.presentEmailSent(response: response)
            }
        }

    }
    
    func getEmail(request: SendEmail.GetEmail.Request){
        if let email = email {
            let response = SendEmail.GetEmail.Response(email: email)
            presenter?.presentEmail(response: response)
        }
    }
    
    func validateForm(email: String) -> String? {
        let formFields: [UserFormField] = [
            UserFormField(name: "Email", value: email, type: .email)
        ]
        
        let error = validationWorker.validateFields(formFields)

        if let error = error {
            let response = SendEmail.SendEmail.Response(error: error)
            presenter?.presentEmailSent(response: response)
            return error
        }
        
        return nil
    }
}
