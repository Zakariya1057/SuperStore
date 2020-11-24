//
//  ForgotPasswordViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 17/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UserDelegate {

    @IBOutlet weak var emailField: UITextField!
    var userHandler = UserHandler()
    
    let spinner: SpinnerViewController = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.delegate = self
        userHandler.delegate = self
        
        emailField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        let email = emailField.text ?? ""
        
        let validationFields: [ [String: String] ] = [
            ["field": "email", "value": email, "type": "email"],
        ]
        
        let error = userHandler.validateFields(validationFields)
        
        if error != nil {
            return showError(error!)
        }

        startLoading()
        userHandler.requestResetCode(email: email)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "emailToCode" {
            let destinationVC = segue.destination as! CheckCodeViewController
            let email = emailField.text ?? ""
            destinationVC.email = email
        }
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
    
    func showStatus(){
        let alert = UIAlertController(title: "Code Sent", message: "If user exists an email will be sent to the email address.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func contentLoaded() {
        stopLoading()
        self.performSegue(withIdentifier: "emailToCode", sender: self)
    }
    
    func errorHandler(_ message: String) {
        stopLoading()
        showError(message)
    }
    
    func logOutUser(){
        userHandler.userSession.viewController = self
        userHandler.requestLogout()
    }

}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 100
    }
    
}
