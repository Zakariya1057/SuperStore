//
//  MainViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 09/09/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }


}
