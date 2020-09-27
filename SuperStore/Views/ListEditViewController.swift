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
    
    @IBOutlet weak var name_field: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if list != nil {
            name_field.text = list?.name
        }
    }
    
    @IBAction func change_store_pressed(_ sender: Any) {
    }
    
    @IBAction func restart_list_pressed(_ sender: Any) {
        listHandler.restart(list_id: list!.id)
        list!.status = .notStarted
        self.delegate?.updateList(list: list!, index: list_index!)
    }
    
    @IBAction func save_pressed(_ sender: Any) {
        let name = name_field.text ?? ""
        
        list!.name = name
        
        self.delegate?.updateList(list: list!, index: list_index!)
        
        listHandler.update(list_data: [
            "list_id": String(list!.id),
            "name":name,
            "store_type_id": "1"
        ])
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
