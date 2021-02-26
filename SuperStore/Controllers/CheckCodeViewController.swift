//
//  TokenViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class CheckCodeViewController: UIViewController, UserDelegate {

    var email: String?
    @IBOutlet weak var codeField: UITextField!
    
    let spinner: SpinnerViewController = SpinnerViewController()
    var userHandler = UserHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userHandler.delegate = self
        codeField.delegate = self
        
        codeField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "codeToResetPassword" {
            let destinationVC = segue.destination as! ResetPasswordViewController
//            destinationVC.email = email
//            destinationVC.code = codeField.text
        }
    }
    
    @IBAction func checkPressed(_ sender: Any) {
        let code = codeField.text ?? ""
        
        let validationFields: [ [String: String] ] = [
            ["field": "code", "value": code, "type": "code"],
        ]
        
        let error = userHandler.validateFields(validationFields)
        
        if error != nil {
            return showError(error!)
        }

        startLoading()
        userHandler.requestValidateCode(email: email!, code: code)
    }
    
    func startLoading() {
        view.endEditing(true)
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
        self.performSegue(withIdentifier: "codeToResetPassword", sender: self)
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

extension CheckCodeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 20
    }
    
}
