//
//  SendEmailViewController.swift
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

protocol SendEmailDisplayLogic: class
{
    func displayEmail(viewModel: SendEmail.GetEmail.ViewModel)
    func displayEmailSent(viewModel: SendEmail.SendEmail.ViewModel)
}

class SendEmailViewController: UIViewController, SendEmailDisplayLogic
{
    
    var interactor: SendEmailBusinessLogic?
    var router: (NSObjectProtocol & SendEmailRoutingLogic & SendEmailDataPassing)?
    
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
        let interactor = SendEmailInteractor()
        let presenter = SendEmailPresenter()
        let router = SendEmailRouter()
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
        showEmail()
        setupTextFieldDelegate()
    }
    
    let spinner: SpinnerViewController = SpinnerViewController()
    
    @IBOutlet weak var emailField: UITextField!
    
    func showEmail()
    {
        interactor?.getEmail(request: SendEmail.GetEmail.Request())
    }
    
    func submitForm(){
        let email = emailField.text ?? ""
        let request = SendEmail.SendEmail.Request(email: email)
        interactor?.sendEmail(request: request)
    }
    
    //MARK: - Display
    
    func displayEmailSent(viewModel: SendEmail.SendEmail.ViewModel)
    {
        stopLoading()
        
        let error = viewModel.error
        
        if let error = error {
            showError(title: "Send Email Error", error: error)
        } else {
            router?.routeToVerifyCode(segue: nil)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func sendResetEmailButtonPressed(_ sender: Any) {
        startLoading()
        dismissKeyboard()
        submitForm()
    }
    
    //MARK: - Extra
    private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func displayEmail(viewModel: SendEmail.GetEmail.ViewModel) {
        emailField.text = viewModel.email
    }

}

extension SendEmailViewController {
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

extension SendEmailViewController: UITextFieldDelegate {
    
    private func setupTextFieldDelegate(){
        emailField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        startLoading()
        dismissKeyboard()
        submitForm()
        
        return true
    }
}
