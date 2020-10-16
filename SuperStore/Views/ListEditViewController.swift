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
        return realm.objects(ListHistory.self).filter("index = \(list_index!)").first
    }
    
//    var list:ListModel?
    
//    var delegate: ListChangedDelegate?
    var list_index: Int?
    
    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(list)
        
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
            
            self.realm.beginWrite()
            self.list!.restartList()
            
            do {
                print("Saving Changes")
                try self.realm.commitWrite()
            } catch {
                print(error)
            }
            
            self.listHandler.restart(list_index: self.list_index!)
            
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
        
        do {
            print("Saving Changes")
            try self.realm.commitWrite()
        } catch {
            print(error)
        }
        
//        self.delegate?.updateList(list: list!, index: list_index!)
        
        listHandler.update(list_data: [
            "index": String(list!.index),
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
