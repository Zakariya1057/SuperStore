//
//  NewPasswordInteractor.swift
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

protocol NewPasswordBusinessLogic
{
    func newPassword(request: NewPassword.NewPassword.Request)
}

protocol NewPasswordDataStore
{
    var email: String { get set }
    var code: String { get set }
}

class NewPasswordInteractor: NewPasswordBusinessLogic, NewPasswordDataStore
{
    var email: String = ""
    var code: String = ""
    
    var presenter: NewPasswordPresentationLogic?
    
    var resetWorker: ResetPasswordWorker = ResetPasswordWorker(passwordReset: ResetPasswordAPI())
    var validationWorker: UserValidationWorker = UserValidationWorker()
    
    func newPassword(request: NewPassword.NewPassword.Request)
    {
        let password = request.password
        let passwordConfirm = request.passwordConfirm
        
        let error = validateForm(password: password, passwordConfirm: passwordConfirm)
        
        if error == nil {
            resetWorker.newPassword(email: email, code: code, password: password, passwordConfirmation: passwordConfirm) { (user: UserModel?, error: String?) in
                let response = NewPassword.NewPassword.Response(error: error)
                self.presenter?.presentNewPassword(response: response)
            }
        }

    }
    
    func validateForm(password: String, passwordConfirm: String) -> String? {
        
        let formFields: [UserFormField] = [
            UserFormField(name: "Email", value: email, type: .email),
            UserFormField(name: "Password", value: password, type: .password),
            UserFormField(name: "Confirm Password", value: passwordConfirm, type: .password),
            UserPasswordMatch(name: "Password match", value: password, type: .confirm, repeatValue: passwordConfirm)
        ]
        
        let error = validationWorker.validateFields(formFields)

        if let error = error {
            let response = NewPassword.NewPassword.Response(error: error)
            self.presenter?.presentNewPassword(response: response)
            return error
        }
        
        return nil
    }
}