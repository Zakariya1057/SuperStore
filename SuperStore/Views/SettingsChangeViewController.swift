//
//  SettingsChangeViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsChangeViewController: UIViewController, UserDelegate {

    var headerName:String = ""
    var type: String?
    var inputValue:String?
    
    let realm = try! Realm()
    
    @IBOutlet var saveBarItem: UIBarButtonItem!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    
    var userHandler = UserHandler()
    
    var userDetails: UserHistory? {
        return userSession.getUserDetails()
    }
    
    var userSession:UserSession {
        return userHandler.userSession
    }
    
    let spinner: SpinnerViewController = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerLabel.text = headerName
        
        inputField.text = inputValue ?? ""
        
        self.type = headerName.lowercased()
        if type == "email" {
            inputField.keyboardType = .emailAddress
        } else {
            inputField.keyboardType = .asciiCapable
        }
        
        inputField.delegate = self
        userHandler.delegate = self
        
        inputField.becomeFirstResponder()
    }
    

    @IBAction func donePressed(_ sender: Any) {
        
        let input = inputField.text ?? ""
        
        let validationFields: [[String: String]] = [["field": type!, "value": input, "type": type!]]
        
        let error = userHandler.validateFields(validationFields)
        
        if error != nil {
            return showError(error!)
        }
        
        let userData = ["type": type!, type!: input]
        
        view.endEditing(true)
        
        startLoading()
        userHandler.requestUpdate(userData: userData)
        
    }

    func showError(_ error: String){
        let alert = UIAlertController(title: "Update Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func contentLoaded() {
        stopLoading()
        
        try? realm.write({
            userDetails![type!] = inputField.text!
        })
        
        self.navigationController!.popViewController(animated: true)
    }
    
    func errorHandler(_ message: String) {
        stopLoading()
        showError(message)
    }

    func logOutUser(){
        userHandler.userSession.viewController = self
        userHandler.requestLogout()
    }
    
    func startLoading() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        saveBarItem.isEnabled = false
    }
    
    func stopLoading(){
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
        saveBarItem.isEnabled = true
    }
    
}

extension SettingsChangeViewController: UITextFieldDelegate {
    
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
