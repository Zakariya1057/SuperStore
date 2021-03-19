//
//  LoginWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SwiftKeychainWrapper
import AuthenticationServices

class LoginWorker {
    
    public func appleLogin(appleIDCredential: ASAuthorizationAppleIDCredential) -> UserHistory? {
        
        let userIdentifier = appleIDCredential.user
        let userFullName = appleIDCredential.fullName
        let userEmail = appleIDCredential.email
        
        print("User id is \(userIdentifier) \n Full Name is \(String(describing: userFullName)) \n Email id is \(String(describing: userEmail))")
        
        let user = UserHistory()
        
        user.userToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)!
        user.identifier = userIdentifier
        
        if userEmail != nil && userFullName != nil {
            user.email = userEmail!
            user.name = "\(userFullName!.givenName!) \(userFullName!.familyName!)"
            storeUserInKeyChain(user: user)
        } else if userIdentifier != "" {
            
            // User identifier found instead. This can mean:
            
            // 1. User already register.  Get details from storage. Send Details Endpoint.
            // 2. User login previously failed. Network Error. Get details from storage. Send Details To Endpoint.
            
            let userSettings = KeychainWrapper.standard.data(forKey: "appleUserAccounts")
            
            if userSettings != nil {
                let userInfo = retrieveUserFromKeyChain(userSettings: userSettings!)
                
                if let userInfo = userInfo {
                    user.email = userInfo.email
                    user.name = userInfo.name
                } else {
                    print("Error: No User Found Saved In History.")
                    return nil
                }

                
            } else {
                print("Error: No User Found In History.")
                return nil
            }
            
        }
        
        return user
        
    }
    
    func generatePassword() -> String {
        let length = 30
        let passwordCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        return String((0..<length).compactMap{ _ in passwordCharacters.randomElement() })
    }
    
    private func storeUserInKeyChain(user: UserHistory){
        KeychainWrapper.standard.set(try! PropertyListEncoder().encode(user), forKey: "appleUserAccounts")
    }
    
    private func retrieveUserFromKeyChain(userSettings: Data) -> UserHistory? {
        return try? PropertyListDecoder().decode(UserHistory.self, from: userSettings)
    }
    
}
