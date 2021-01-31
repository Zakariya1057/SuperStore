//
//  RegisterViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 17/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import RealmSwift
import AuthenticationServices

class RegisterViewController: UIViewController, UserDelegate {
    var userHandler = UserHandler()

    let realm = try! Realm()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    
    var fields: [UITextField] {
        return [nameField,emailField,passwordField,repeatPasswordField]
    }
    
    let spinner: SpinnerViewController = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userHandler.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        repeatPasswordField.delegate = self
        
        nameField.delegate = self
        
        for (index, field) in fields.enumerated() {
            field.tag = index
        }
        
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
        
        let validationFields: [[String: String]] = [
            ["field": "name", "value": name, "type": "name"],
            ["field": "email", "value": email, "type": "email"],
            ["field": "password", "value": password, "type": "password"],
            ["field": "confirm password", "value": passwordConfirmation, "type": "password"],
        ]
        
        let error = userHandler.validateFields(validationFields)
        
        if error != nil {
            return showError(error!)
        }
        
        if passwordConfirmation != password {
            return showError("Passwords don't match")
        }
        
        view.endEditing(true)
        
        startLoading()
        userHandler.requestRegister(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
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
    
    func contentLoaded() {
        stopLoading()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.removeFromSuperview()
        performSegue(withIdentifier: "registerToHome", sender: self)
    }
    
    func errorHandler(_ message: String) {
        stopLoading()
        showError(message)
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Register Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func logOutUser(){
        userHandler.userSession.viewController = self
        userHandler.requestLogout()
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 100
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        if textField.tag == (fields.count - 1) {
            repeatPasswordField.resignFirstResponder()
        } else {
            fields[textField.tag + 1].becomeFirstResponder()
        }

        return false
    }
    
}
