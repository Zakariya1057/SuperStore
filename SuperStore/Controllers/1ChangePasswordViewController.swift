////
////  ChangePasswordViewController.swift
////  SuperStore
////
////  Created by Zakariya Mohummed on 02/08/2020.
////  Copyright © 2020 Zakariya Mohummed. All rights reserved.
////
//
//import UIKit
//
//class ChangePasswordViewController: UIViewController, UserDelegate {
//
//    @IBOutlet var saveBarItem: UIBarButtonItem!
//    
//    @IBOutlet weak var currentPasswordField: UITextField!
//    @IBOutlet weak var newPasswordField: UITextField!
//    @IBOutlet weak var repeatPasswordField: UITextField!
//    
//    var userHandler = UserHandler()
//    
//    let spinner: SpinnerViewController = SpinnerViewController()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        userHandler.delegate = self
//        
//        currentPasswordField.delegate = self
//        newPasswordField.delegate = self
//        repeatPasswordField.delegate = self
//        
//        currentPasswordField.becomeFirstResponder()
//    }
//    
//    @IBAction func savePressed(_ sender: Any) {
//        let currentPassword = currentPasswordField.text ?? ""
//        let newPassword = newPasswordField.text ?? ""
//        let passwordConfirmation = repeatPasswordField.text ?? ""
//        
//        let validationFields: [[String: String]] = [
//            ["field": "Current Password", "value": currentPassword, "type": "password"],
//            ["field": "New Password", "value": newPassword, "type": "password"],
//            ["field": "Repeat Password", "value": passwordConfirmation, "type": "password"],
//        ]
//        
//        let error = userHandler.validateFields(validationFields)
//        
//        if error != nil {
//            return showError(error!)
//        }
//        
//        if passwordConfirmation != newPassword {
//            return showError("Passwords don't match")
//        }
//        
//        view.endEditing(true)
//        
//        startLoading()
//        
//        userHandler.requestUpdate(userData: ["type": "password","current_password": currentPassword, "password": newPassword, "password_confirmation": passwordConfirmation])
//        
//    }
//    
//    func showError(_ error: String){
//        let alert = UIAlertController(title: "Update Error", message: error, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//        self.present(alert, animated: true)
//    }
//    
//    func contentLoaded() {
//        stopLoading()
//        self.navigationController!.popViewController(animated: true)
//    }
//    
//    func errorHandler(_ message: String) {
//        stopLoading()
//        showError(message)
//    }
//
//    func logOutUser(){
//        userHandler.userSession.viewController = self
//        userHandler.requestLogout()
//    }
//    
//    func startLoading() {
//        addChild(spinner)
//        spinner.view.frame = view.frame
//        view.addSubview(spinner.view)
//        spinner.didMove(toParent: self)
//        saveBarItem.isEnabled = false
//    }
//    
//    func stopLoading(){
//        spinner.willMove(toParent: nil)
//        spinner.view.removeFromSuperview()
//        spinner.removeFromParent()
//        saveBarItem.isEnabled = true
//    }
//    
//}
//
//extension ChangePasswordViewController: UITextFieldDelegate {
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        guard let textFieldText = textField.text,
//            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
//                return false
//        }
//        
//        let substringToReplace = textFieldText[rangeOfTextToReplace]
//        let count = textFieldText.count - substringToReplace.count + string.count
//        return count <= 100
//    }
//    
//}
