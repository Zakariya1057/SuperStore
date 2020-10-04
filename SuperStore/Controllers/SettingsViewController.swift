//
//  SettingsTableViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

protocol UserDetailsChangedDelegate {
    func updateUserDetails(userDetails: UserData)
}

class SettingsViewController: UIViewController, UserDetailsChangedDelegate {
    
    @IBOutlet weak var usernameStackView: UIStackView!
    
    @IBOutlet weak var emailStackView: UIStackView!
    
    @IBOutlet weak var passwordStackView: UIStackView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var fieldName:String = ""
    var fieldValue:String = ""
    
    var userDetails: UserData?
    
    let userHandler = UserHandler()
    var userSession:UserSession {
        return userHandler.userSession
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDetails = userSession.getUserDetails()
        
        let usernanmeGesture = UITapGestureRecognizer(target: self, action: #selector(usernamePressed))
        usernameStackView.addGestureRecognizer(usernanmeGesture)
        
        let emailGesture = UITapGestureRecognizer(target: self, action: #selector(emailPressed))
        emailStackView.addGestureRecognizer(emailGesture)
        
        let passwordGesture = UITapGestureRecognizer(target: self, action: #selector(passswordPressed))
        passwordStackView.addGestureRecognizer(passwordGesture)
    }
    
    func showUserDetails(){
        nameLabel.text = userDetails?.name
        emailLabel.text = userDetails?.email
    }
    
    @objc func usernamePressed(){
        fieldName = "Name"
        fieldValue = userDetails!.name
        self.performSegue(withIdentifier: "settingsToSettingChange", sender: self)
    }
    
    @objc func emailPressed(){
        fieldName = "Email"
        fieldValue = userDetails!.email
        self.performSegue(withIdentifier: "settingsToSettingChange", sender: self)
    }
    
    @objc func passswordPressed(){
        fieldName = "Password"
        self.performSegue(withIdentifier: "settingsToChangePassword", sender: self)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in self.logOut()} ))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsToSettingChange" {
            let destinationVC = segue.destination as! SettingsChangeViewController
            destinationVC.delegate = self
            destinationVC.userDetails = userDetails
            destinationVC.inputValue = fieldValue
            destinationVC.headerName = fieldName
        }
    }
    
    func logOut(){
        userHandler.requestLogout()
        userSession.logOut()
    
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "loginViewController"))! as! LoginViewController
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateUserDetails(userDetails: UserData) {
        self.userDetails = userDetails
        userSession.setLoggedIn(userDetails)
        showUserDetails()
    }
}
