//
//  IngredientsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class IngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    let ingredients_list = [
        "Flour (54%) (Wheat Flour, Calcium, Iron, Niacin, Thiamin)",
        "Vegetable Oil (Palm)",
        "Wholemeal Wheat Flour (16%)",
        "Sugar, Partially Inverted Sugar Syrup",
        "Raising Agents (Sodium Bicarbonate, Malic Acid, Ammonium Bicarbonate)",
        "Salt",
        "Dried Skimmed Milk"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
//        ingredientsTableView.register(UINib(nibName: K.Cells.ReviewCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ReviewCell.CellIdentifier)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.ReviewCell.CellIdentifier , for: indexPath) as! ReviewTableViewCell
        let cell = UITableViewCell()
        cell.textLabel?.text = ingredients_list[indexPath.row]
        cell.textLabel?.numberOfLines = 3
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
}
