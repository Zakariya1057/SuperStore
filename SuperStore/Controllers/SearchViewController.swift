//
//  SearchViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController,UISearchBarDelegate, SearchSuggestionsDelegate {
    
    @IBOutlet weak var searchTableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchList:[SearchModel] = []
    
    var suggestions:[SearchModel] = []
    
    let realm = try! Realm()
    lazy var searchHistory: Results<SearchHistory> = { self.realm.objects(SearchHistory.self).filter("searchType = 'history'").sorted(byKeyPath: "usedAt", ascending: false) }()
    
    var searchHandler: SearchHandler = SearchHandler()
    
    var ignoreResults: Bool = false
    
    var selectedItem:SearchModel?
    
    var delegate:GroceryDelegate?
    
    var loading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        searchBar.delegate = self
        
        populateDefaultSearch()
        
        showHistory()
//        self.searchList = history
        
        searchHandler.suggestionsDelegate = self
       
        searchTableView.register(UINib(nibName: K.Cells.SearchCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.SearchCell.CellIdentifier)
        
    }
    
    
    func errorHandler(_ message: String) {
        showError(message)
        loading = false
        searchTableView.reloadData()
    }
    
    func contentLoaded(suggestions: [SearchModel]) {
        if !ignoreResults {
            loading = false
            self.suggestions = suggestions
            
            for suggestion in suggestions {
                addToSearchSuggestions(suggestion: suggestion)
            }
            
            showSuggestions()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Started Editing")
        
        if searchBar.text == "" {
            showHistory()
        } else {
            showSuggestions()
        }
        
    }

    func showHistory(){
        print("Show History")
        var history:[SearchModel] = []
        
        for item in searchHistory {
            history.append(SearchModel(id: item.id, name: item.name, type: SearchType(rawValue: item.type)!))
        }
        
        print(self.searchList)
        
        self.searchList = history
        searchTableView.reloadData()
    }
    
    func showSuggestions(){
        print("Show Suggestions")
        self.searchList = suggestions
        searchTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text
        
        ignoreResults = false
        
        if text != nil {
            if text != "" {
                search(text: text!)
            } else {
                loading = false
                searchTableView.reloadData()
                ignoreResults = true
                showHistory()
            }
            
        } else {
            showHistory()
        }

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(text: searchBar.text ?? "")
    }
    
    
    func search(text: String){
        loading = true
        searchSuggestionsHistory(text)
        searchHandler.requestSuggestions(query: text)
        searchTableView.reloadData()
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Search Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}

extension SearchViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 3 : searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier:K.Cells.SearchCell.CellIdentifier , for: indexPath) as! SearchTableViewCell
        
        if loading == false {
            cell.search = searchList[indexPath.row]
            cell.configureUI()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        } else {
            cell.startLoading()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = searchList[indexPath.row]
        
        addToSearchHistory(search: selectedItem!)
        
        if selectedItem!.type == .store {
            self.performSegue(withIdentifier: "searchToStoreResults", sender: self)
        } else {
            self.performSegue(withIdentifier: "showSearchResults", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearchResults" {
            let destinationVC = segue.destination as! SearchResultsViewController
            destinationVC.searchName = selectedItem!.name
            destinationVC.delegate = self.delegate
            
            var type:String
            
            if selectedItem!.type == .childCategory {
                type = "child_categories"
            } else if selectedItem!.type == .parentCategory {
                type = "parent_categories"
            } else {
                type = "products"
            }
            
            destinationVC.type = type
        } else if segue.identifier == "searchToStoreResults" {
            let destinationVC = segue.destination as! SearchStoresViewController
            destinationVC.store_type_id =  selectedItem!.id
            destinationVC.delegate = self.delegate
        }
    }
    
}

extension SearchViewController {
    
    func addToSearchHistory(search: SearchModel){
        
        if realm.objects(SearchHistory.self).filter("searchType = 'history' AND name = %@", search.name).count == 0 {
            try! realm.write() {
               
                realm.add(search.getSearchObject("history"))
                
                let items = realm.objects(SearchHistory.self).filter("searchType = 'history'", search.name).sorted(byKeyPath: "usedAt", ascending: false)
                print(items.count)
                
                if items.count > 5 {

                    print("Removing Older Items From History")
                    
                    var removeResults:[SearchHistory] = []

                    for i in 5...(items.count - 1) {
                        removeResults.append(items[i])
                    }

                    realm.delete(removeResults)
                }
                
            }
        } else {
            print("Duplicate Search History Ignore: \(search.name)")
        }
    }
    
    func addToSearchSuggestions(suggestion: SearchModel){
        if realm.objects(SearchHistory.self).filter("searchType = 'suggestion' AND name = %@",suggestion.name).count == 0 {
            try! realm.write() { // 2
                print("Adding To Suggestions Table")
                realm.add(suggestion.getSearchObject("suggestion"))
            }
        } else {
            
        }
    }
    
    func populateDefaultSearch() {
      if searchHistory.count == 0 { // 1

        let defaultHistory:[SearchModel] = [SearchModel(id: 1, name: "Asda", type: .store), SearchModel(id: 1, name: "Fruit", type: .parentCategory)]

        for search in defaultHistory {
            addToSearchHistory(search: search)
        }
        
      }
        
    }
    
    func searchSuggestionsHistory(_ search: String){
        let history = realm.objects(SearchHistory.self).filter("searchType = 'suggestion' AND name CONTAINS %@", search)
        searchList = []
        
        for item in history {
            searchList.append(SearchModel(id: item.id, name: item.name, type: SearchType(rawValue: item.type)!))
        }
    
        if searchList.count > 0 {
            loading = false
            searchTableView.reloadData()
        }
        
    }
    
}
