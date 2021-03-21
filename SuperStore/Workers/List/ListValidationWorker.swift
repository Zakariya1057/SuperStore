//
//  ListValidationWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 04/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ListValidationWorker {

    func validateFields(_ validationFields: [ListFormField]) -> String? {
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
            
            if type == .identifier {
                if !isValidIdentifier(value){
                    return "Invalid Identifier."
                }
            }

            if type == .storeTypeID {
                if !isValidStoreTypeID(value){
                    return "\(fieldName) must be at least 8 characters long."
                }
            }
        }
        
        return nil
    }
    
    func isValidName(_ name: String) -> Bool {
        return name.count >= 3
    }
    
    func isValidIdentifier(_ identifier: String) -> Bool {
        let identifierRegex = #"^^\w+-\w+-\w+-\w+-\w+$$"#
        let identifierPred = NSPredicate(format:"SELF MATCHES %@", identifierRegex)
        return identifierPred.evaluate(with: identifier)
    }

    func isValidStoreTypeID(_ storeTypeID: String) -> Bool {
        return true
    }
}

class ListFormField {
    
    var name: String
    var value: String
    var type: ListFormType
    
    init(name: String, value: String, type: ListFormType) {
        self.name = name
        self.value = value
        self.type = type
    }
}

enum ListFormType {
    case name
    case storeTypeID
    case identifier
}
