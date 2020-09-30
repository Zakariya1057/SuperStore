//
//  ListsEditViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 13/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ListEditViewController: UIViewController  {
    
    var listHandler = ListsHandler()
    
    var list:ListModel?
    
    var delegate: ListChangedDelegate?
    var list_index: Int?
    
    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if list != nil {
            nameField.text = list?.name
        }
    }
    
    func validateName() -> String? {
        let name = nameField.text ?? ""
        
        if name == "" {
            return "List name required."
        }
        
        return nil
    }
    
    func confirmRestart(){
        let alert = UIAlertController(title: "Restarting List?", message: "Sure you want to uncheck all items in this list?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .destructive, handler: { (_) in
            self.listHandler.restart(list_id: self.list!.id)
            self.list!.status = .notStarted
            self.delegate?.updateList(list: self.list!, index: self.list_index!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func restart_list_pressed(_ sender: Any) {
        confirmRestart()
    }
    
    @IBAction func save_pressed(_ sender: Any) {
        
        let error = validateName()
        if error != nil {
            return showError(error!)
        }
        
        list!.name = nameField.text!
        
        self.delegate?.updateList(list: list!, index: list_index!)
        
        listHandler.update(list_data: [
            "list_id": String(list!.id),
            "name":nameField.text!,
            "store_type_id": "1"
        ])
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "List Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}
