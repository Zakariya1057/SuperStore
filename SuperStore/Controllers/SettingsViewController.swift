//
//  SettingsTableViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var usernameStackView: UIStackView!
    
    @IBOutlet weak var emailStackView: UIStackView!
    
    @IBOutlet weak var passwordStackView: UIStackView!
    
    var fieldName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usernanmeGesture = UITapGestureRecognizer(target: self, action: #selector(usernamePressed))
        usernameStackView.addGestureRecognizer(usernanmeGesture)
        
        let emailGesture = UITapGestureRecognizer(target: self, action: #selector(emailPressed))
        emailStackView.addGestureRecognizer(emailGesture)
        
        let passwordGesture = UITapGestureRecognizer(target: self, action: #selector(passswordPressed))
        passwordStackView.addGestureRecognizer(passwordGesture)
    }
    
    @objc func usernamePressed(){
        print("Username Pressed")
        fieldName = "Name"
        self.performSegue(withIdentifier: "settingsToSettingChange", sender: self)
    }
    
    @objc func emailPressed(){
        print("Email Pressed")
        fieldName = "Email"
        self.performSegue(withIdentifier: "settingsToSettingChange", sender: self)
    }
    
    @objc func passswordPressed(){
        print("Password Pressed")
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
            destinationVC.headerName = fieldName
        } else {

        }

    }
    
    func logOut(){
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "loginViewController"))! as! LoginViewController
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
