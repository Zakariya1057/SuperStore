//
//  NewListViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import RealmSwift

class NewListViewController: UIViewController, ListDelegate {
    
    let realm = try! Realm()
    
    @IBOutlet weak var nameField: UITextField!
    
    let spinner: SpinnerViewController = SpinnerViewController()
    var userHandler = UserHandler()
    
    var listIndex: Int?
    
    @IBOutlet var createBarItem: UIBarButtonItem!
    var listHandler = ListsHandler()
    
    var offline: Bool {
        return RequestHandler.sharedInstance.offline
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        listHandler.delegate = self
        
        nameField.becomeFirstResponder()
    }
    
    func contentLoaded(lists: [ListModel]) {
        // Update sync
        print("Content Loaded")
        
        let list = realm.objects(ListHistory.self).filter("identifier = %@", lists[0].identifier).first
        if list != nil {
            try? realm.write({
                print("Setting Synced To True")
                list!.id = lists[0].id
                list!.synced = true
            })
        }
        
        stopLoading()
        self.navigationController?.popViewController(animated: true)
    }
    
    func errorHandler(_ message: String) {
        showError(message)
    }
    
    func logOutUser() {
        userHandler.userSession.viewController = self
        userHandler.requestLogout()
    }

    @IBAction func created_pressed(_ sender: Any) {
        let error = validateName()
        if error != nil {
            return showError(error!)
        }
        
        createList()
    }
    
}

extension NewListViewController {

    func createList(){
        
        startLoading()
        
        let list = ListModel(id: 0, name: nameField.text!, createdAt: Date(), status: .notStarted, identifier: UUID().uuidString, storeID: 1, userID: 1, totalPrice: 0, categories: [], totalItems: 0, tickedOffItems: 0)
            
        try! realm.write() {
            realm.add(list.getRealmObject())
        }
        
        listHandler.insert(list_data: ["name": list.name,"identifier": list.identifier,"store_type_id": "1"])
        
        if offline {
            stopLoading()
            self.navigationController?.popViewController(animated: true)
        }
    }

    func validateName() -> String? {
        let name = nameField.text ?? ""
        
        if name == "" {
            return "List name required."
        }
        
        return nil
    }

    func showError(_ error: String){
        let alert = UIAlertController(title: "List Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

}

extension NewListViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 50
    }
    
}

extension NewListViewController {
    func startLoading() {
        view.endEditing(true)
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
        createBarItem.isEnabled = false
    }
    
    func stopLoading(){
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
        createBarItem.isEnabled = true
    }
}
