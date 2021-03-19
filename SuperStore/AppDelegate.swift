//
//  AppDelegate.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 21/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UIKit
import RealmSwift

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let notificationDelegate = CustomNotificationDelegate()
    
    var navigationController: UINavigationController = UINavigationController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        let config = Realm.Configuration(
          schemaVersion: 0
        )

        Realm.Configuration.defaultConfiguration = config
        
//        try? FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        configureNotification(application: application)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
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
    

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
      }
    
    // This function will be called right after user tap on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let content = response.notification.request.content.userInfo
        
        if let aps = content["aps"] as? [String: AnyObject] {

            if let notificationData: AnyObject = aps["data"] {
                
                let productID: Int = notificationData["product_id"]! as! Int
                
                if let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)

                    if let destinationVC = storyboard.instantiateViewController(withIdentifier: "ShowProductViewController") as? ShowProductViewController,
                        let tabBarController = rootViewController as? UITabBarController,
                        let navController = tabBarController.selectedViewController as? UINavigationController {
                        destinationVC.interactor?.productID = productID
                        navController.pushViewController(destinationVC, animated: true)
                    }
                    
                }

            }
            
        }
    
        completionHandler()
    }

    // Enables user permission
    func configureNotification(application: UIApplication) {
           let center = UNUserNotificationCenter.current()
           center.delegate = notificationDelegate
           center.requestAuthorization(options: [.badge, .sound, .alert]) { granted, _ in
               guard granted else { return }
               DispatchQueue.main.async {
                    UNUserNotificationCenter.current().delegate = self
                    application.registerForRemoteNotifications()
               }
           }
   }

}
