//
//  SearchResultsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var resultsTableView: UITableView!
    
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var filterView: UIView!
    
    let items:[String] = ["Burger","Bread","Toast","Burger","Bread","Toast","Burger","Bread","Toast"]
    
    var delegate:GroceryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        
        resultsTableView.rowHeight = 140;

        let sortGesture = UITapGestureRecognizer(target: self, action: #selector(sortResults))
        sortView.addGestureRecognizer(sortGesture)
        
        let filterGesture = UITapGestureRecognizer(target: self, action: #selector(filterResults))
        filterView.addGestureRecognizer(filterGesture)
        // Do any additional setup after loading the view.
    }
        
    @objc func filterResults(){
        self.performSegue(withIdentifier: "resultsOption", sender: self)
    }
    
    @objc func sortResults(){
        self.performSegue(withIdentifier: "resultsOption", sender: self)
    }
        
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTableView.dequeueReusableCell(withIdentifier:K.Cells.GroceryCell.CellIdentifier , for: indexPath) as! GroceryTableViewCell
        cell.delegate = self.delegate
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         self.delegate?.show_grocery_item(1)
    }


}
