//
//  NewListViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import RealmSwift

class NewListViewController: UIViewController {
    
    var delegate: NewListDelegate?
    
    let realm = try! Realm()
    
    @IBOutlet weak var nameField: UITextField!
    
    let spinner: SpinnerViewController = SpinnerViewController()
    
    var listIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func validateName() -> String? {
        let name = nameField.text ?? ""
        
        if name == "" {
            return "List name required."
        }
        
        return nil
    }
    
    func createList(){
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd MMMM Y"
//
//        let created_at = formatter.string(from: date)
        
        let list = ListModel(id: 1, name: nameField.text!, created_at: Date(), status: .notStarted, identifier: UUID().uuidString, store_id: 1, user_id: 1, totalPrice: 0, categories: [])
            
        try! realm.write() {
            realm.add(list.getRealmObject())
        }
        
        self.delegate?.addNewList(list)
        
    }

    @IBAction func created_pressed(_ sender: Any) {
        let error = validateName()
        if error != nil {
            return showError(error!)
        }
        
        createList()
        self.navigationController!.popViewController(animated: true)
    }
    
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "List Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}
