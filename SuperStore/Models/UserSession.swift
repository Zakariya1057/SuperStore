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
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.removeObject(forKey: "userSettings")
    }
    
    func setLoggedIn(_ tokenData:UserData){
        userDefaults.set(try? PropertyListEncoder().encode(tokenData), forKey: "userSettings")
    }
    
    func getUserToken() -> String? {
        //Check if user is logged in or not. If logged in, show recent. Otherwise show home page
        let details = getUserDetails()
        return details?.token
    }
    
    func getUserDetails() -> UserData? {
        guard let userSettings = userDefaults.object(forKey: "userSettings") as? Data else {
            return nil
        }
        
        // Use PropertyListDecoder to convert Data into Player
        guard let details = try? PropertyListDecoder().decode(UserData.self, from: userSettings) else {
            return nil
        }
        
        return details
    }
    
    func isLoggedIn() -> Bool{
        let loggedIn:Bool = getUserToken() != nil
        return loggedIn
    }
    
}
