//
//  SettingsChangeViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/08/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class SettingsChangeViewController: UIViewController {

    var headerName:String = ""
    var type: String?
    
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    
    var userHandler = UserHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerLabel.text = headerName
        
        self.type = headerName.lowercased()
        if type == "email" {
            inputField.keyboardType = .emailAddress
        } else {
            inputField.keyboardType = .asciiCapable
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func donePressed(_ sender: Any) {
        
        let input = inputField.text ?? ""
        
        if type == "email" {
            userHandler.requestUpdate(userData: ["type": type!, "email": input])
        } else {
            userHandler.requestUpdate(userData: ["type": type!, "name": input])
        }
        
        self.navigationController!.popViewController(animated: true)
    }


}
