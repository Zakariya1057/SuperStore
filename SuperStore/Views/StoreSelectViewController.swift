//
//  AddProductViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 30/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class StoreSelectViewController: UIViewController {
    
    var suggestionsElements: [UILabel] = []
    
//    var delegate: StoreSelectedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func storeButtonClicked(_ sender: UIButton) {
//        self.delegate?.storeChanged(name: sender.titleLabel!.text!, backgroundColor: sender.backgroundColor!)
        self.navigationController!.popViewController(animated: true)
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
