//
//  SearchViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var searchTableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchList:[String] = []
    
    var history:[String] = ["Fries","Burgers","Tesco"]
    var suggestions:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        searchBar.delegate = self
        
        self.searchList = history
        
        searchTableView.register(UINib(nibName: K.Cells.SearchCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.SearchCell.CellIdentifier)
        
        searchTableView.rowHeight = 80;
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Started Editing")
        showSuggestions()
    }

    func showHistory(){
        print("Show History")
        self.searchList = history
        searchTableView.reloadData()
    }
    
    func showSuggestions(){
        print("Show Suggestions")
        suggestions = ["Fried","Fruits"]
        self.searchList = suggestions
        searchTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text
        
        if text != nil && text == "" {
            showHistory()
        } else {
            showSuggestions()
        }
        
    }
}

extension SearchViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
        let cell = searchTableView.dequeueReusableCell(withIdentifier:K.Cells.SearchCell.CellIdentifier , for: indexPath) as! SearchTableViewCell
//        cell.textLabel?.text = searchList[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "searchToStoreResults", sender: self)
        self.performSegue(withIdentifier: "showSearchResults", sender: self)
    }
}
