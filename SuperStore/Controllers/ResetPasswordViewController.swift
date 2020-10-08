//
//  ResetPasswordViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController, UserDelegate {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    var code: String?
    var email: String?
    
    var userHandler = UserHandler()
    let spinner: SpinnerViewController = SpinnerViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userHandler.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changePressed(_ sender: Any) {
        let password: String = passwordField.text ?? ""
        let passwordConfirmation: String = confirmPasswordField.text ?? ""
        
        let validationFields: [[String: String]] = [
            ["field": "password", "value": password, "type": "password"],
            ["field": "confirm password", "value": passwordConfirmation, "type": "password"],
        ]
        
        let error = userHandler.validateFields(validationFields)
        
        if error != nil {
            return showError(error!)
        }

        startLoading()
        userHandler.requestResetPassword(userData: ["email": email!,"code": code!,"password": password, "password_confirmation": passwordConfirmation])

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
        let alert = UIAlertController(title: "Password Reset Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func contentLoaded() {
        stopLoading()
        self.performSegue(withIdentifier: "resetPasswordToHome", sender: self)
    }
    
    func errorHandler(_ message: String) {
        stopLoading()
        showError(message)
    }

}