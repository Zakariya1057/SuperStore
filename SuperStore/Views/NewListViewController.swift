//
//  NewListViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class NewListViewController: UIViewController {
    
    var delegate: NewListDelegate?
    
    @IBOutlet weak var nameField: UITextField!
    
    let spinner: SpinnerViewController = SpinnerViewController()
    
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
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM Y"
        
        let created_at = formatter.string(from: date)
        
        self.delegate?.addNewList( ListModel(id: 1, name: nameField.text!, created_at: created_at, status: .notStarted, store_id: 1, user_id: 1, total_price: 0, categories: []) )
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
