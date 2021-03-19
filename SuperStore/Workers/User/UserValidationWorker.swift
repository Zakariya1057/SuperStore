//
//  UserValidationWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class UserValidationWorker {

    func validateFields(_ validationFields: [UserFormField]) -> String? {
        for field in validationFields {

            let value = field.value
            let fieldName = field.name
            let type = field.type
            
            if value == "" {
                return "\(fieldName) required."
            }

            if type == .name {
                if !isValidName(value){
                    return "\(fieldName) must be at least 3 characters long."
                }
            }
            
            if type == .email {
                if !isValidEmail(value){
                    return "Invalid Email."
                }
            }

            if type == .password {
                if !isValidPassword(value){
                    return "\(fieldName) must be at least 8 characters long."
                }
            }
            
            if type == .code {
                if !isValidCode(value){
                    return "\(fieldName) must be at least 7 characters long."
                }
            }
            
            if type == .confirm {
                let passwordConfirm = (field as! UserPasswordMatch).repeatValue
                if !isMatchingPasswords(value, passwordConfirm){
                    return "Your password and confirmation password must match."
                }
            }
        }
        
        return nil
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    func isMatchingPasswords(_ password1: String, _ password2: String) -> Bool {
        return password1 == password2
    }

    func isValidName(_ name: String) -> Bool {
        return name.count >= 3
    }

    func isValidCode(_ code: String) -> Bool {
        return code.count >= 7
    }
}

class UserFormField {
    
    var name: String
    var value: String
    var type: UserFormFieldType
    
    init(name: String, value: String, type: UserFormFieldType) {
        self.name = name
        self.value = value
        self.type = type
    }
}

class UserPasswordMatch: UserFormField {
    var repeatValue: String
    
    init(name: String, value: String, type: UserFormFieldType, repeatValue: String) {
        self.repeatValue = repeatValue
        super.init(name: name, value: value, type: type)
    }
}

enum UserFormFieldType {
    case email
    case name
    case password
    case code
    case confirm
}
