//
//  AppleUserSession.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import AuthenticationServices

struct AppleUserSession {
//    
//    public func login(appleIDCredential: ASAuthorizationAppleIDCredential) -> UserObject {
//
//        let userIdentifier = appleIDCredential.user
//        let userFullName = appleIDCredential.fullName
//        let userEmail = appleIDCredential.email
//
//        print("User id is \(userIdentifier) \n Full Name is \(String(describing: userFullName)) \n Email id is \(String(describing: userEmail))")
//
//        let user = UserObject()
//
//        user.password = generatePassword()
//        user.userToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)!
//        user.identifier = userIdentifier
//        
//        if userEmail != nil && userFullName != nil {
//            user.email = userEmail!
//            user.name = "\(userFullName!.givenName!) \(userFullName!.familyName!)"
//            
//            KeychainWrapper.standard.set(try! PropertyListEncoder().encode(user), forKey: "appleUserAccounts")
//            
//        } else if userIdentifier != "" {
//            // User identifier found instead. This can mean:
//            // 1. User already register.  Get details from storage. Send Details Endpoint.
//            // 2. User login previously failed. Network Error. Get details from storage. Send Details Endpoint.
//            
//            let userSettings = KeychainWrapper.standard.data(forKey: "appleUserAccounts")
//            
//            if userSettings != nil {
//                let userInfo = try? PropertyListDecoder().decode(UserObject.self, from: userSettings!)
//                
//                user.email = userInfo!.email
//                user.name = userInfo!.name
//                user.password = userInfo!.password
//                
//            } else {
//                print("Error: No User Found In History.")
//            }
//            
//        }
//        
//        return user
//        
//    }
//    
//    func generatePassword() -> String {
//        let length = 20
//        let passwordCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
//        return String((0..<length).compactMap{ _ in passwordCharacters.randomElement() })
//    }

}
