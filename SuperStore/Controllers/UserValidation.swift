//
//  Validation.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

extension UserHandler {
    
    func validateFields(_ validationFields: [[String: String]]) -> String? {
        
        for field in validationFields {
            let type = field["type"]!
            let value = field["value"]!
            let fieldName = field["field"]!.capitalized
            
            if value == "" {
                return "\(fieldName) required."
            }
            
            if type == "email" {
                if !isValidEmail(value){
                    return "Invalid Email."
                }
            }
            
            if type == "password"{
                if !isValidPassword(value){
                    return "\(fieldName) must be at least 8 characters."
                }
            }
            
            if type == "name"{
                if !isValidName(value){
                    return "\(fieldName) must be at least 3 characters."
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
    
    func isValidName(_ name: String) -> Bool {
        return name.count >= 3
    }
    
}
