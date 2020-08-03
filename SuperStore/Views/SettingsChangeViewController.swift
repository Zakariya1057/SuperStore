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
    
    @IBOutlet weak var inputField: UITextField!
    
    @IBAction func donePressed(_ sender: Any) {
        //Save Changes, Go Back
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBOutlet weak var headerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerLabel.text = headerName
        
        if headerName.lowercased() == "email" {
            inputField.keyboardType = .emailAddress
        } else {
            inputField.keyboardType = .asciiCapable
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
