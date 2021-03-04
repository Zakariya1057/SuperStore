//
//  EditEmailViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EditEmailDisplayLogic: class
{
    func displayEmail(viewModel: EditEmail.GetEmail.ViewModel)
    func displayEmailUpdated(viewModel: EditEmail.UpdateEmail.ViewModel)
}

class EditEmailViewController: UIViewController, EditEmailDisplayLogic
{

    var interactor: EditEmailBusinessLogic?
    var router: (NSObjectProtocol & EditEmailRoutingLogic & EditEmailDataPassing)?
    
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
        let interactor = EditEmailInteractor()
        let presenter = EditEmailPresenter()
        let router = EditEmailRouter()
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
    }
    
    let spinner: SpinnerViewController = SpinnerViewController()
    
    @IBOutlet weak var emailTextField: UITextField!
    
    func getEmail()
    {
        let request = EditEmail.GetEmail.Request()
        interactor?.getEmail(request: request)
    }
    
    func saveEmail(){
        startLoading()
        
        let request = EditEmail.UpdateEmail.Request(email: emailTextField.text ?? "")
        interactor?.updateEmail(request: request)
    }
    
    
    func displayEmail(viewModel: EditEmail.GetEmail.ViewModel)
    {
        emailTextField.text = viewModel.email
    }
    
    func displayEmailUpdated(viewModel: EditEmail.UpdateEmail.ViewModel) {
        stopLoading()
        
        if let error = viewModel.error {
            showError(title: "Update Error", error: error)
        } else {
            router?.routeToSettings(segue: nil)
        }
    }
}

extension EditEmailViewController {
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveEmail()
    }
}

extension EditEmailViewController {
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
