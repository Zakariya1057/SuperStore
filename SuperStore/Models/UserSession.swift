//
//  UserSession.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

struct UserSession {
    
    let userDefaults = UserDefaults.standard
    
    func logOut(){
        UserDefaults.standard.removeObject(forKey: "userSettings")
    }
    
    func setLoggedIn(_ userData:UserHistory){
        userDefaults.set(try? PropertyListEncoder().encode(userData), forKey: "userSettings")
        setDefaultRealmForUser()
    }
    
    func getUserToken() -> String? {
        let details = getUserDetails()
        return details?.token
    }
    
    func getUserDetails() -> UserHistory? {
        guard let userSettings = userDefaults.object(forKey: "userSettings") as? Data else {
            return nil
        }
        
        // Use PropertyListDecoder to convert Data into Player
        guard let details = try? PropertyListDecoder().decode(UserHistory.self, from: userSettings) else {
            return nil
        }
        
        return details
    }
    
    func isLoggedIn() -> Bool{
        let loggedIn:Bool = getUserToken() != nil
        return loggedIn
    }
    
    func setDefaultRealmForUser() {
        var config = Realm.Configuration()

        let userId = self.getUserDetails()!.id
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(userId).realm")

        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }

    
}
