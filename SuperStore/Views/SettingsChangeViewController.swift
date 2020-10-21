//
//  SettingsChangeViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class SettingsChangeViewController: UIViewController, UserDelegate {

    var headerName:String = ""
    var type: String?
    var inputValue:String?
    
//    var delegate: UserDetailsChangedDelegate?
    
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    
    var userHandler = UserHandler()
    
    var userDetails: UserHistory?
    
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
        // Do any additional setup after loading the view.
    }
    

    @IBAction func donePressed(_ sender: Any) {
        
        let input = inputField.text ?? ""
        
        if type == "email" {
            
            let validationFields: [ [String: String] ] = [
                ["field": "email", "value": input, "type": "email"],
            ]
            
            let error = userHandler.validateFields(validationFields)
            
            if error != nil {
                return showError(error!)
            }

            userDetails!.email = input
            
            startLoading()
            
            userHandler.requestUpdate(userData: ["type": type!, "email": input])
        } else {
            let validationFields: [ [String: String] ] = [
                ["field": "name", "value": input, "type": "name"],
            ]
            
            userDetails!.name = input
            let error = userHandler.validateFields(validationFields)
            
            if error != nil {
                return showError(error!)
            }

            startLoading()
            
//            self.delegate?.updateUserDetails(userDetails: userDetails!)
            userHandler.requestUpdate(userData: ["type": type!, "name": input])
        }
        
    }

    func showError(_ error: String){
        let alert = UIAlertController(title: "Update Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func contentLoaded() {
        stopLoading()
        self.navigationController!.popViewController(animated: true)
    }
    
    func errorHandler(_ message: String) {
        stopLoading()
        showError(message)
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
