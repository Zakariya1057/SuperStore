//
//  EditListViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 04/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EditListDisplayLogic: class
{
    func displayList(viewModel: EditList.GetList.ViewModel)
    func displayListRestarted(viewModel: EditList.RestartList.ViewModel)
    func displayListUpdated(viewModel: EditList.UpdateList.ViewModel)
}

class EditListViewController: UIViewController, EditListDisplayLogic
{
    var interactor: EditListBusinessLogic?
    var router: (NSObjectProtocol & EditListRoutingLogic & EditListDataPassing)?
    
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
        let interactor = EditListInteractor()
        let presenter = EditListPresenter()
        let router = EditListRouter()
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
        setupFieldDelegate()
        openKeyboardOnTextField()
        getList()
    }
    
    let spinner: SpinnerViewController = SpinnerViewController()
    
    @IBOutlet weak var nameTextField: UITextField!
    
    func getList()
    {
        let request = EditList.GetList.Request()
        interactor?.getList(request: request)
    }

    func displayList(viewModel: EditList.GetList.ViewModel)
    {
        nameTextField.text = viewModel.name
    }
    
    func displayListRestarted(viewModel: EditList.RestartList.ViewModel){
        stopLoading()
        
        if let error = viewModel.error {
            showRightBarButton()
            showError(title: "Restart Error", error: error)
        } else {
            router?.routeToShowLists(segue: nil)
        }
    }
    
    func displayListUpdated(viewModel: EditList.UpdateList.ViewModel){
        stopLoading()
        
        if let error = viewModel.error {
            showRightBarButton()
            showError(title: "Update Error", error: error)
        } else {
            router?.routeToShowLists(segue: nil)
        }
    }
    
    func submitForm(){
        startLoading()
        hideRightBarButton()
        dismissKeyboard()
        
        let name = nameTextField.text ?? ""
        let request = EditList.UpdateList.Request(name: name)
        interactor?.updateList(request: request)
    }

}

extension EditListViewController {
    @IBAction func restartButtonPressed(_ sender: UIButton) {
        startLoading()
        hideRightBarButton()

        let request = EditList.RestartList.Request()
        interactor?.restartList(request: request)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        submitForm()
    }
}

extension EditListViewController {
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func showRightBarButton(){
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func hideRightBarButton(){
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func openKeyboardOnTextField(){
        nameTextField.becomeFirstResponder()
    }
}

extension EditListViewController: UITextFieldDelegate {
    
    private func setupFieldDelegate(){
        nameTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        dismissKeyboard()
        submitForm()
        return true
    }
}

extension EditListViewController {
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
