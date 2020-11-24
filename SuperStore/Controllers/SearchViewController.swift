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
    
    var userHandler = UserHandler()
    
    var searchHandler: SearchHandler = SearchHandler()
    
    var ignoreResults: Bool = false
    
    var selectedItem:SearchModel?
    
    var selectedListID: Int?
    
    var loading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        searchBar.delegate = self
        
        populateDefaultSearch()
        
        showHistory()
        
        searchHandler.suggestionsDelegate = self
        
        searchTableView.register(UINib(nibName: K.Cells.SearchCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.SearchCell.CellIdentifier)
        
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
    
    func errorHandler(_ message: String) {
        showError(message)
        loading = false
        searchTableView.reloadData()
    }
    
    func logOutUser(){
        userHandler.userSession.viewController = self
        userHandler.requestLogout()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            showHistory()
        } else {
            showSuggestions()
        }
        
    }

    func showHistory(){
        var history:[SearchModel] = []
        
        for item in searchHistory {
            history.append(SearchModel(id: item.id, name: item.name, type: SearchType(rawValue: item.type)!))
        }
        
        self.searchList = history
        searchTableView.reloadData()
    }
    
    func showSuggestions(){
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
            destinationVC.searchDetails = self.selectedItem
            destinationVC.selectedListID = self.selectedListID
        } else if segue.identifier == "searchToStoreResults" {
            let destinationVC = segue.destination as! SearchStoresViewController
            destinationVC.storeTypeID =  self.selectedItem!.id
            destinationVC.selectedListID = self.selectedListID
        }
    }
    
}

extension SearchViewController {
    
    func addToSearchHistory(search: SearchModel){
        
        if realm.objects(SearchHistory.self).filter("searchType = 'history' AND name = %@", search.name).count == 0 {
            try! realm.write() {
               
                realm.add(search.getSearchObject("history"))
                
                let items = realm.objects(SearchHistory.self).filter("searchType = 'history'", search.name).sorted(byKeyPath: "usedAt", ascending: false)
                
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
        if realm.objects(SearchHistory.self).filter("searchType = 'suggestion' AND name = %@",suggestion.name).first == nil {
            addToCategories(suggestion: suggestion)
            addToHistory(suggestion: suggestion)
        }
    }
    
    func populateDefaultSearch() {
      if searchHistory.count == 0 {

        let defaultHistory:[SearchModel] = [SearchModel(id: 1, name: "Apples", type: .childCategory), SearchModel(id: 1, name: "Fruit", type: .parentCategory), SearchModel(id: 1, name: "Asda", type: .store)]

        for suggestion in defaultHistory {
            addToSearchHistory(search: suggestion)
            addToCategories(suggestion: suggestion)
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
    
    func addToCategories(suggestion: SearchModel){
        
        try! realm.write() {
            
            if suggestion.type == .childCategory {
                
                if realm.objects(ChildCategoryHistory.self).filter("id = %@",suggestion.id).first == nil {
                    let category = ChildCategoryHistory()
                    category.id = suggestion.id
                    category.name = suggestion.name
                    
                    realm.add(category)
                }
            }
            
        }

    }
    
    func addToHistory(suggestion: SearchModel){
        try! realm.write() {
            realm.add(suggestion.getSearchObject("suggestion"))
        }
    }
    
}
