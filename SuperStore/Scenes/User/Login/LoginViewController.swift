//
//  LoginViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import AuthenticationServices

protocol LoginDisplayLogic: AnyObject
{
    func displayLoggedInUser(viewModel: Login.Login.ViewModel)
}

class LoginViewController: UIViewController, LoginDisplayLogic
{
    var interactor: LoginBusinessLogic?
    var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let router = LoginRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpSignInAppleButton()
        setupTextFieldDelegates()
    }
    
    let spinner: SpinnerViewController = SpinnerViewController()
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet var appleSignInStackView: UIStackView!
    
    //MARK: - Display
    
    func displayLoggedInUser(viewModel: Login.Login.ViewModel)
    {
        stopLoading()
        
        if viewModel.error == nil {
            router?.routeToLoggedIn(segue: nil)
        } else {
            let error = viewModel.error!
            showError(title: "Login Failed", error: error)
        }
        
    }
    
    //MARK: - Actions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        startLoading()
        dismissKeyboard()
        submitForm()
    }
    
    private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    private func submitForm(){
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""

        let request = Login.Login.Request(email: email, password: password)
        interactor?.login(request: request)
    }
}

extension LoginViewController {
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

extension LoginViewController: UITextFieldDelegate {
    
    private func setupTextFieldDelegates(){
        for field in textFields {
            field.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        if let index = textFields.firstIndex(of: textField) {
            if index < textFields.count - 1 {
                let nextTextField = textFields[index + 1]
                nextTextField.becomeFirstResponder()
            } else {
                startLoading()
                dismissKeyboard()
                submitForm()
            }
        }
        return true
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func setUpSignInAppleButton() {
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        
        authorizationButton.cornerRadius = 0
        self.appleSignInStackView.addArrangedSubview(authorizationButton)
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
            let request = Login.AppleLogin.Request(appleIDCredential: appleIDCredential)
            startLoading()
            interactor?.appleLogin(request: request)
        } else {
            showError(title: "Apple Login Error", error: "Error occured please try again later.")
        }
    }
}

