//
//  UserSession.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftKeychainWrapper

struct UserSession {
    
    init() {
        setDefaultRealmForUser()
    }
    
    let userDefaults = UserDefaults.standard
    
    var viewController: UIViewController?
    
    func logOut(){
        let realm = try! Realm()
        UserDefaults.standard.removeObject(forKey: "userSettings")
        
        resetDefaultRealm()
        
        try? realm.write({
            realm.delete(realm.objects(UserHistory.self))
        })
    
        if viewController != nil {
            let destinationVC = (viewController!.storyboard?.instantiateViewController(withIdentifier: "loginViewController"))! as! LoginViewController
            viewController!.navigationController?.setNavigationBarHidden(true, animated: true)
            viewController!.tabBarController?.tabBar.isHidden = true
            viewController!.navigationController?.pushViewController(destinationVC, animated: true)
        }

    }
    
    func deleteUser(){
        try? FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func setLoggedIn(_ userData:UserHistory){
        setDefaultRealmForUser(userId: userData.id)
        saveUserInfo(userData: userData)
        
        let realm = try! Realm()
       
        try? realm.write({
            realm.add(userData)
        })
    }
    
    func getUserToken() -> String? {
        let details = getUserDetails()
        return details?.token
    }
    
    func getUserDetails() -> UserHistory? {
        let realm = try? Realm()
        return realm?.objects(UserHistory.self).first
    }
    
    private func showUserInfo() -> UserHistory? {
        guard let userSettings =  KeychainWrapper.standard.data(forKey: "userSetting") else {
            return nil
        }
        
        // Use PropertyListDecoder to convert Data into Player
        guard let details = try? PropertyListDecoder().decode(UserHistory.self, from: userSettings) else {
            return nil
        }
        
        return details
    }
    
    private func saveUserInfo(userData: UserHistory){
        KeychainWrapper.standard.set(try! PropertyListEncoder().encode(userData), forKey: "userSetting")
    }
    
    func isLoggedIn() -> Bool{
        return showUserInfo() != nil && getUserDetails() != nil
    }
    
    func setDefaultRealmForUser(userId: Int? = nil) {
        var config = Realm.Configuration()
        
        let userId: Int? = userId != nil ? userId : showUserInfo()?.id
        
        if userId != nil {
           
            // Use the default directory, but replace the filename with the username
            config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(userId!).realm")

            // Set this as the configuration used for the default Realm
            Realm.Configuration.defaultConfiguration = config
        }

    }
    
    func resetDefaultRealm(){
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("default.realm")
        Realm.Configuration.defaultConfiguration = config
    }

}
