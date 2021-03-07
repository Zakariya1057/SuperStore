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
        configureStorePicker()
        getEmail()
        setupTextFieldDelegates()
    }
    
    // MARK: Outlets
    
    var selectedStoreType: StoreTypeModel = StoreTypeModel(id: 2, name: "Real Canadian Superstore", type: .realCanadianSuperstore)
    
    let storeTypes: [StoreTypeModel] = [
        StoreTypeModel(id: 2, name: "Real Canadian Superstore", type: .realCanadianSuperstore),
        StoreTypeModel(id: 1, name: "Asda", type: .asda),
    ]
    
    var storeTypePicker: UIPickerView = UIPickerView()
    
    let spinner: SpinnerViewController = SpinnerViewController()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    @IBOutlet var storeField: UITextField!
    
    @IBOutlet var textFields: [UITextField]!
    
    //MARK: - Actions
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        startLoading()
        dismissKeyboard()
        submitForm()
    }
    
    func configureStorePicker(){
        storeField.inputView = storeTypePicker
        storeTypePicker.delegate = self
        storeTypePicker.dataSource = self
        storeField.text = selectedStoreType.name
    }
    
    //MARK: - Display
    
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
            router?.routeToLoggedIn(segue: nil)
        }
    }
    
    //MARK: - Extra
    
    private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    private func submitForm(){
        let name = nameField.text ?? ""
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        let passwordConfirm = passwordConfirmField.text ?? ""
        
        let request = Register.Register.Request(
            name: name,
            email: email,
            storeTypeID: selectedStoreType.id,
            password: password,
            passwordConfirm: passwordConfirm
        )
        
        interactor?.register(request: request)
    }
    
    func getEmail()
    {
        let request = Register.GetEmail.Request()
        interactor?.getEmail(request: request)
    }
}

extension RegisterViewController {
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
                startLoading()
                dismissKeyboard()
                submitForm()
            }
        }
        return true
    }
}

extension RegisterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return storeTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return storeTypes[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedStoreType = storeTypes[row]
        storeField.text = selectedStoreType.name
    }
    
}
