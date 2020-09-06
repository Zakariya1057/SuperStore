//
//  SearchStoresTableViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 29/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class SearchStoresTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var mapTableView: UITableView!
    @IBOutlet weak var storesTableView: UITableView!
    
    var storesList = ["1","2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapTableView.delegate = self
        self.mapTableView.dataSource = self
        
        self.storesTableView.delegate = self
        self.storesTableView.dataSource = self

        mapTableView.register(UINib(nibName: K.Cells.StoreMapCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.StoreMapCell.CellIdentifier)
        storesTableView.register(UINib(nibName: K.Cells.StoresResultsCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.StoresResultsCell.CellIdentifier)
        
        storesTableView.rowHeight = 100;
        mapTableView.rowHeight = 300
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == storesTableView {
            return 10
        } else if tableView == mapTableView {
            return 1
        }
        
        return 0
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(100)
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mapTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.StoreMapCell.CellIdentifier) as! StoresMapTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
            } else if tableView ==  storesTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.StoresResultsCell.CellIdentifier) as! StoresResultsTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "storeResultsToStore", sender: self)
    }
    
}
