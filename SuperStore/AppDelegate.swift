//
//  AppDelegate.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 21/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    var navigationController: UINavigationController = UINavigationController()
    
    var notificationWorker: NotificationWorker?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 7,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 4) {
                    migration.enumerateObjects(ofType: UserObject.className()) { oldObject, newObject in
                        newObject!["regionID"] = 8
                    }
                }
            })
        
        
        Realm.Configuration.defaultConfiguration = config
        
//        try? FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        notificationWorker = NotificationWorker()
        
        configureNotification(application: application)
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        print("Device token: \(token)")
        UserSessionWorker.notificationToken = token
    }
    
    // This function will be called when notification is received
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
        notificationWorker?.notificationReceived(data: notification.request.content.userInfo)
    }
    
    // This function will be called right after user tap on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        notificationWorker?.notificationPressed(response: response)
        completionHandler()
    }
    
    // Enables user permission
    func configureNotification(application: UIApplication) {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert]) { granted, _ in
            guard granted else { return }
            DispatchQueue.main.async {
                UNUserNotificationCenter.current().delegate = self
                application.registerForRemoteNotifications()
            }
        }
        
    }
    
}
