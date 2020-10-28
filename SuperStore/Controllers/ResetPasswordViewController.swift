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
        
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        passwordField.tag = 0
        confirmPasswordField.tag = 1
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

extension ResetPasswordViewController: UITextFieldDelegate {
    
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
    
        if textField.tag == 0 {
            confirmPasswordField.becomeFirstResponder()
        } else {
            confirmPasswordField.resignFirstResponder()
        }

        return false
    }
    
}
