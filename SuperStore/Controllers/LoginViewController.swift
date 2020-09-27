//
//  MainViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 09/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UserDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var userHandler = UserHandler()
    
    let spinner: SpinnerViewController = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userHandler.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func loginPressed(_ sender: Any) {
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        
        let validationFields: [ [String: String] ] = [
            ["field": "email", "value": email, "type": "email"],
            ["field": "password", "value": password, "type": "password"],
        ]
        
        let error = userHandler.validateFields(validationFields)
        
        if error != nil {
            return showError(error!)
        }

        startLoading()
        userHandler.requestLogin(email: email, password: password)
    }
    
    func startLoading() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func stopLoading(){
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Login Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func contentLoaded() {
        stopLoading()
        self.performSegue(withIdentifier: "loginToHome", sender: self)
    }
    
    func errorHandler(_ message: String) {
        stopLoading()
        showError(message)
    }
    
}
