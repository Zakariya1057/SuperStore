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
    
    static var sharedInstance: UserSession = {
        return UserSession()
    }()
    
    let userDefaults = UserDefaults.standard
    
    var viewController: UIViewController?
    
    var notificationToken: String?
    
    func logOut(){
        let realm = try! Realm()
        UserDefaults.standard.removeObject(forKey: "userSettings")
        
        try? realm.write({
            realm.deleteAll()
        })
    
        if viewController != nil && isLoggedIn() == false {
            let destinationVC = (viewController!.storyboard?.instantiateViewController(withIdentifier: "homeViewController"))!
            viewController!.navigationController?.setNavigationBarHidden(true, animated: true)
            viewController!.tabBarController?.tabBar.isHidden = true
            viewController!.navigationController?.pushViewController(destinationVC, animated: true)
        }

    }
    
    func deleteUser(){
        try? FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func setLoggedIn(_ userData:User){
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
    
    func getUserDetails() -> User? {
        let realm = try? Realm()
        return realm?.objects(User.self).first
    }
    
    private func showUserInfo() -> User? {
        guard let userSettings =  KeychainWrapper.standard.data(forKey: "userSetting") else {
            return nil
        }
        
        // Use PropertyListDecoder to convert Data into Player
        guard let details = try? PropertyListDecoder().decode(User.self, from: userSettings) else {
            return nil
        }
        
        return details
    }
    
    private func saveUserInfo(userData: User){
        KeychainWrapper.standard.set(try! PropertyListEncoder().encode(userData), forKey: "userSetting")
    }
    
    func isLoggedIn() -> Bool{
        return showUserInfo() != nil && getUserDetails() != nil
    }

}
