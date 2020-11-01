//
//  ListsEditViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 13/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import RealmSwift

class ListEditViewController: UIViewController  {
    
    var listHandler = ListsHandler()
    
    let realm = try! Realm()
    
    var list: ListHistory? {
        return realm.objects(ListHistory.self).filter("identifier = %@", identifier!).first
    }

    var identifier: String?
    
    @IBOutlet weak var nameField: UITextField!
    
    var offline: Bool {
        return RequestHandler.sharedInstance.offline
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        
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
        let alert = UIAlertController(title: "Restarting List?", message: "Are you sure you want to uncheck all items in this list?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .destructive, handler: { (_) in
            
            self.realm.beginWrite()
            self.list!.restartList()
            
            do {
                print("Saving Changes")
                try self.realm.commitWrite()
            } catch {
                print(error)
            }
            
            self.listHandler.restart(listID: self.list!.id)
            
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
        
        self.realm.beginWrite()
        list!.name = nameField.text!
        list!.edited = true
        
        do {
            print("Saving Changes")
            try self.realm.commitWrite()
        } catch {
            print(error)
        }
        
        listHandler.update(list_data: [
            "identifier": list!.identifier,
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

extension ListEditViewController: UITextFieldDelegate {
    
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
