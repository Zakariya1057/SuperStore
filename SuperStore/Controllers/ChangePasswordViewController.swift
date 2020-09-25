//
//  ChangePasswordViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    
    let userHandler = UserHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let currentPassword = currentPasswordField.text ?? ""
        let newPassword = newPasswordField.text ?? ""
        let repeatPassword = repeatPasswordField.text ?? ""
        
        userHandler.requestUpdate(userData: ["type": "password","current_password": currentPassword, "password": newPassword, "password_confirmation": repeatPassword])
        self.navigationController!.popViewController(animated: true)
    }


}
