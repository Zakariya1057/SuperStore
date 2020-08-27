//
//  ListsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

protocol NewListDelegate {
    func addNewList(_ list: ListModel)
}

class ListsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,NewListDelegate {
    
    @IBOutlet weak var listsTableView: UITableView!
    
    var lists:[ListModel] = [
        
        ListModel(name: "Grocery List", store: StoreModel(name: "Asda", logo: "", opening_hours: [], location: LocationModel(city: "Birmingham", address_line1: "", address_line2: "", address_line3: "", postcode: ""), facilities: []))
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listsTableView.register(UINib(nibName: K.Cells.ListCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ListCell.CellIdentifier)
        
        listsTableView.delegate = self
        listsTableView.dataSource = self
        listsTableView.rowHeight = 80;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.ListCell.CellIdentifier , for: indexPath) as! ListsTableViewCell
        cell.list = lists[indexPath.row]
        cell.configureUI()
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "listToGroceryList", sender: self)
    }
    
    @IBAction func newListPressed(_ sender: Any) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "newListViewController"))! as! NewListViewController
        
        destinationVC.delegate = self
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func addNewList(_ list: ListModel) {
        self.lists.append(list)
        self.listsTableView.reloadData()
    }
    
}
