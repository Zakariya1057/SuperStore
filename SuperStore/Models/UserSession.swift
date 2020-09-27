//
//  UserSession.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct UserSession {
    
    let userDefaults = UserDefaults.standard
    
    func logOut(){
        print("Logging Out User")
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.removeObject(forKey: "user_token")
    }
    
    func setLoggedIn(_ tokenData:UserData){
        print("Setting User Token: \(tokenData.token)")
        userDefaults.set(try? PropertyListEncoder().encode(tokenData), forKey: "user_token")
    }
    
    func getUserToken() -> String? {
        //Check if user is logged in or not. If logged in, show recent. Otherwise show home page
        
        print("Checking If User Logged In")
        
        guard let user_token = userDefaults.object(forKey: "user_token") as? Data else {
            return nil
        }
        
        print("Decoding Token")
        print(user_token)
        
        // Use PropertyListDecoder to convert Data into Player
        guard let token = try? PropertyListDecoder().decode(UserData.self, from: user_token) else {
            return nil
        }
        
        return token.token
    }
    
    func isLoggedIn() -> Bool{
        let loggedIn:Bool = getUserToken() != nil
        print("User Logged In: \(loggedIn)")
        return loggedIn
    }
    
}
