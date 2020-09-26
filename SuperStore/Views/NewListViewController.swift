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
    
    var storeName:String = ""
    
//    @IBOutlet weak var storeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        storeButton.backgroundColor = .clear
//        storeButton.layer.cornerRadius = 5
//        storeButton.layer.borderWidth = 1
//        storeButton.layer.borderColor = UIColor.lightGray.cgColor
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func storeButtonPressed(_ sender: Any) {
        print("Select Store")
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "storeSelectViewController"))! as! StoreSelectViewController
        
//        destinationVC.delegate = self
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
//    func storeChanged(name: String, backgroundColor: UIColor) {
//        
//        self.storeName = name
//        
//        storeButton.setTitle(name, for: .normal)
//        storeButton.backgroundColor = backgroundColor
//        storeButton.setTitleColor(.white, for: .normal)
//    }
    
    @IBAction func created_pressed(_ sender: Any) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM Y"
        
        let created_at = formatter.string(from: date)
        
        self.delegate?.addNewList( ListModel(id: 1, name: nameField.text!, created_at: created_at, status: .notStarted, store_id: 1, user_id: 1, total_price: 0, categories: []) )
        self.navigationController!.popViewController(animated: true)
    }
    
}
