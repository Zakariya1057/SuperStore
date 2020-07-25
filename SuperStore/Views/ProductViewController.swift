//
//  ProductViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    @IBOutlet weak var ingredientsView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(showIngredients))
        ingredientsView.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
    }
    

    @objc func showIngredients(){
//        print("Show \(K.Paths.showIngredients)")
        self.performSegue(withIdentifier: "showIngredients", sender: self)
    }

}
