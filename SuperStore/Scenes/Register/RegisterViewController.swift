//
//  RegisterViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol RegisterDisplayLogic: class
{
    func displayUserEmail(viewModel: Register.GetEmail.ViewModel)
    func displayRegisteredUser(viewModel: Register.Register.ViewModel)
}

class RegisterViewController: UIViewController, RegisterDisplayLogic
{
    var interactor: RegisterBusinessLogic?
    var router: (NSObjectProtocol & RegisterRoutingLogic & RegisterDataPassing)?
    
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
        let interactor = RegisterInteractor()
        let presenter = RegisterPresenter()
        let router = RegisterRouter()
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
        getEmail()
        setupTextFieldDelegates()
    }
    
    // MARK: Do something
    let spinner: SpinnerViewController = SpinnerViewController()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        startLoading()
        submitForm()
    }
    
    private func submitForm(){
        let name = nameField.text ?? ""
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        let passwordConfirm = passwordConfirmField.text ?? ""
        
        let request = Register.Register.Request(
            name: name, email: email,
            password: password, passwordConfirm: passwordConfirm
        )
        
        interactor?.register(request: request)
    }
    
    func getEmail()
    {
        let request = Register.GetEmail.Request()
        interactor?.getEmail(request: request)
    }
    
    func displayUserEmail(viewModel: Register.GetEmail.ViewModel)
    {
        emailField.text = viewModel.email
    }
    
    func displayRegisteredUser(viewModel: Register.Register.ViewModel){
        stopLoading()
        
        let error = viewModel.error
        
        if let error = error {
            showError(title: "Register Error", error: error)
        } else {
            // Navigate To Home
            print("Success")
        }
    }
}

extension RegisterViewController {
    func startLoading() {
        print("Start Loading")
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func stopLoading(){
        print("Stop Loading")
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    
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
                submitForm()
            }
        }
        return true
    }
}
