//
//  RegisterViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 17/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    let userHandler = UserHandler()

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        let name: String = nameField.text ?? ""
        let email: String = emailField.text ?? ""
        let password: String = passwordField.text ?? ""
        let passwordConfirmation: String = repeatPasswordField.text ?? ""
        
        userHandler.requestRegister(name: name, password: password, passwordConfirmation: passwordConfirmation, email: email)
        performSegue(withIdentifier: "registerToHome", sender: self)
    }
    
}
