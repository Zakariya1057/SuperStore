////
////  SettingsTableViewController.swift
////  SuperStore
////
////  Created by Zakariya Mohummed on 28/07/2020.
////  Copyright © 2020 Zakariya Mohummed. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//
//class SettingsViewController: UIViewController, UserDelegate  {
//
//    @IBOutlet weak var usernameStackView: UIStackView!
//
//    @IBOutlet weak var emailStackView: UIStackView!
//
//    @IBOutlet weak var passwordStackView: UIStackView!
//
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var emailLabel: UILabel!
//    
//    @IBOutlet var notificationSwitch: UISwitch!
//
//    var fieldName:String = ""
//    var fieldValue:String = ""
//
//    let spinner: SpinnerViewController = SpinnerViewController()
//
//    var userDetails: User? {
//        return userSession.getUserDetails()
//    }
//
//    var userHandler = UserHandler()
//    var userSession:UserSession {
//        return userHandler.userSession
//    }
//
//    var notificationToken: NotificationToken?
//
//    let realm = try! Realm()
//
//    var deletePressed: Bool = false
//    var logoutPressed: Bool = false
//
//    var loggedIn: Bool {
//        return userHandler.userSession.isLoggedIn()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let results = realm.objects(User.self)
//
//        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
//            switch changes {
//                case .initial:
//                    self?.showUserDetails()
//                    break
//            case .update(_, _, _, _):
//                    self?.showUserDetails()
//                    break
//                case .error(let error):
//                    fatalError("\(error)")
//            }
//        }
//
//        showUserDetails()
//
//        userHandler.delegate = self
//
//        let usernanmeGesture = UITapGestureRecognizer(target: self, action: #selector(usernamePressed))
//        usernameStackView.addGestureRecognizer(usernanmeGesture)
//
//        let emailGesture = UITapGestureRecognizer(target: self, action: #selector(emailPressed))
//        emailStackView.addGestureRecognizer(emailGesture)
//
//        let passwordGesture = UITapGestureRecognizer(target: self, action: #selector(passswordPressed))
//        passwordStackView.addGestureRecognizer(passwordGesture)
//
//        if !loggedIn {
//            let controller = storyboard!.instantiateViewController(withIdentifier: "loginViewController")
//            addChild(controller)
//            controller.view.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview(controller.view)
//            self.navigationItem.rightBarButtonItem = nil
//
//            NSLayoutConstraint.activate([
//                controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//                controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//                controller.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
//                controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
//            ])
//
//            controller.didMove(toParent: self)
//        }
//
//    }
//
//    deinit {
//        notificationToken?.invalidate()
//    }
//
//    func contentLoaded() {
//        stopLoading()
//
//        userHandler.userSession.viewController = self
//
//        if deletePressed {
//            userHandler.userSession.deleteUser()
//            userSession.logOut()
//        }
//
//        if logoutPressed {
//            userSession.logOut()
//        }
//
//    }
//
//    func errorHandler(_ message: String) {
//        showError(message)
//        stopLoading()
//    }
//
//    func logOutUser(){
//        if userSession.isLoggedIn() {
//            userHandler.userSession.viewController = self
//            userSession.logOut()
//        }
//    }
//
//    func showUserDetails(){
//        nameLabel.text = userDetails?.name
//        emailLabel.text = userDetails?.email
//        notificationSwitch.isOn = userDetails?.sendNotifications ?? true
//    }
//
//    func stopLoading(){
//        spinner.willMove(toParent: nil)
//        spinner.view.removeFromSuperview()
//        spinner.removeFromParent()
//    }
//
//    func startLoading() {
//        addChild(spinner)
//        spinner.view.frame = view.frame
//        view.addSubview(spinner.view)
//        spinner.didMove(toParent: self)
//    }
//
//    @objc func usernamePressed(){
//        fieldName = "Name"
//        fieldValue = userDetails!.name
//        self.performSegue(withIdentifier: "settingsToSettingChange", sender: self)
//    }
//
//    @objc func emailPressed(){
//        fieldName = "Email"
//        fieldValue = userDetails!.email
//        self.performSegue(withIdentifier: "settingsToSettingChange", sender: self)
//    }
//
//    @objc func passswordPressed(){
//        fieldName = "Password"
//        self.performSegue(withIdentifier: "settingsToChangePassword", sender: self)
//    }
//
//    @IBAction func logoutPressed(_ sender: Any) {
//        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in self.logOut()} ))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        self.present(alert, animated: true)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "settingsToSettingChange" {
//            let destinationVC = segue.destination as! SettingsChangeViewController
//            destinationVC.inputValue = fieldValue
//            destinationVC.headerName = fieldName
//        }
//    }
//
//    @IBAction func deletePressed(_ sender: Any) {
//        let alert = UIAlertController(title: "Delete User", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in self.deleteAccount() } ))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        self.present(alert, animated: true)
//    }
//
//    func showError(_ error: String){
//        let alert = UIAlertController(title: "Settings Error", message: error, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//        self.present(alert, animated: true)
//    }
//
//
//    @IBAction func notificationSwitchPressed(_ sender: UISwitch) {
//        // If permission denied, ask user to change app settings notifications.
//
//        let notificationsEnabled = sender.isOn
//
//        try? self.realm.write({
//            self.userDetails!.sendNotifications = notificationsEnabled
//        })
//
//        self.userHandler.requestUpdate(userData: [
//            "type":"send_notifications",
//            "send_notifications": sender.isOn,
//            "notification_token": UserSession.sharedInstance.notificationToken
//        ])
//
//    }
//
//
//    func logOut(){
//        startLoading()
//        logoutPressed = true
//        userHandler.requestLogout()
//    }
//
//    func deleteAccount(){
//        startLoading()
//        deletePressed = true
//        userHandler.requestDelete(userData: ["id": String(userDetails!.id), "email": userDetails!.email])
//    }
//
//}
