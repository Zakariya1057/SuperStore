//
//  MainViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 09/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import AuthenticationServices
import RealmSwift

class LoginViewController: UIViewController, UserDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet var signInButtonStack: UIStackView!
    var userHandler = UserHandler()
    
    let spinner: SpinnerViewController = SpinnerViewController()
    
    let realm = try! Realm()
    let appleSession = AppleUserSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userHandler.delegate = self
        
        emailField.delegate = self
        passwordField.delegate = self
        
        emailField.tag = 0
        passwordField.tag = 1
        setUpSignInAppleButton()

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

        view.endEditing(true)
        
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
        self.tabBarController?.tabBar.removeFromSuperview()
        self.performSegue(withIdentifier: "loginToHome", sender: self)
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

extension LoginViewController: ASAuthorizationControllerDelegate {

    func setUpSignInAppleButton() {
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)

        authorizationButton.cornerRadius = 0
        self.signInButtonStack.addArrangedSubview(authorizationButton)
    }
    
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let user = appleSession.login(appleIDCredential: appleIDCredential)
            userHandler.requestRegister(name:user.name, email: user.email, password: user.password, passwordConfirmation: user.password, identifier: user.identifier, userToken: user.userToken)
            startLoading()
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
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
            passwordField.becomeFirstResponder()
        } else {
            passwordField.resignFirstResponder()
        }

        return false
    }
    
}
