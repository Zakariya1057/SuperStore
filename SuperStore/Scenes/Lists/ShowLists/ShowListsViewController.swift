//
//  ShowListsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 04/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowListsDisplayLogic: AnyObject
{
    func displayLists(viewModel: ShowLists.GetLists.ViewModel)
    func displayListDeleted(viewModel: ShowLists.DeleteList.ViewModel)
    
    func displayListOfflineDeleted(viewModel: ShowLists.Offline.DeletedLists.ViewModel)
    func displayListOfflineEdited(viewModel: ShowLists.Offline.EditedLists.ViewModel)
}

class ShowListsViewController: UIViewController, ShowListsDisplayLogic
{
    
    var interactor: ShowListsBusinessLogic?
    var router: (NSObjectProtocol & ShowListsRoutingLogic & ShowListsDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = ShowListsInteractor()
        let presenter = ShowListsPresenter()
        let router = ShowListsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupListsTableView()
        setupSearchDelegate()
        getLists()
    }
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var listsTableView: UITableView!
    
    var lists: [ListModel] = []
    
    var loading: Bool = true
    
    var editIndexPath: IndexPath?
    
    let spinner: SpinnerViewController = SpinnerViewController()
    var refreshControl = UIRefreshControl()
    
    var userSession: UserSessionWorker = UserSessionWorker()
    var loggedIn: Bool {
        return userSession.isLoggedIn()
    }
    
    func getLists()
    {
        syncDeletedLists()
        syncEditedLists()
        
        let searchText = searchBar.text ?? ""
        
        if loggedIn {
            
            if searchText == "" {
                let request = ShowLists.GetLists.Request()
                interactor?.getLists(request: request)
            } else {
                listSearch()
            }
            
            navigationItem.rightBarButtonItem!.isEnabled = true
        } else {
            refreshControl.endRefreshing()
            navigationItem.rightBarButtonItem!.isEnabled = false
            lists = []
            listsTableView.reloadData()
        }
    }
    
    func displayLists(viewModel: ShowLists.GetLists.ViewModel)
    {
        refreshControl.endRefreshing()
        
        if let error = viewModel.error {
            if !viewModel.offline {
                showError(title: "Lists Error", error: error)
            }
        } else {
            loading = false
            lists = viewModel.lists
            listsTableView.reloadData()
        }
    }
    
    func displayListDeleted(viewModel: ShowLists.DeleteList.ViewModel){
        stopLoading()
        
        if let error = viewModel.error, !viewModel.offline {
            showError(title: "Delete Error", error: error)
        } else {
            lists.remove(at: viewModel.indexPath.row)
            listsTableView.deleteRows(at: [viewModel.indexPath], with: .left)
        }
    }
    
    
    func displayListOfflineEdited(viewModel: ShowLists.Offline.EditedLists.ViewModel) {
        if let error = viewModel.error {
            showError(title: "List Sync Error", error: error)
        }
    }
    
    func displayListOfflineDeleted(viewModel: ShowLists.Offline.DeletedLists.ViewModel) {
        if let error = viewModel.error {
            showError(title: "List Sync Error", error: error)
        }
    }
    
}

extension ShowListsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? (loggedIn ? 5 : 1) : ( (interactor!.addToList && lists.count == 0) ? 1 : lists.count )
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if loggedIn {
            if loading {
                return configureProductCell(indexPath: indexPath)
            } else {
                return (interactor!.addToList && lists.count == 0) ? configureCreateListCell(indexPath: indexPath) : configureProductCell(indexPath: indexPath)
            }
        } else {
            return configureRequestLoginCell(indexPath: indexPath)
        }
    }
    
    func configureRequestLoginCell(indexPath: IndexPath) -> RequestLoginCell {
        let cell = listsTableView.dequeueReusableCell(withIdentifier: "RequestLoginCell", for: indexPath) as! RequestLoginCell
        
        cell.titleLabel.text = "Lists"
        cell.descriptionLabel.text = "Login to view your lists"
        cell.iconImageView.image = UIImage(systemName: "list.dash")
        
        cell.loginButtonPressed = loginButtonPressed
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func configureProductCell(indexPath: IndexPath) -> ListCell {
        let cell = listsTableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        
        cell.list = loading ? nil : lists[indexPath.row]
        cell.loading = loading
        cell.configureUI()
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func configureCreateListCell(indexPath: IndexPath) -> CreateListCell {
        let cell = listsTableView.dequeueReusableCell(withIdentifier: "CreateListCell", for: indexPath) as! CreateListCell
        cell.createListButtonPressed = createListButtonPressed
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func setupListsTableView(){
        let listCellNib = UINib(nibName: "ListCell", bundle: nil)
        listsTableView.register(listCellNib, forCellReuseIdentifier: "ListCell")
        
        let requestLoginCellNib = UINib(nibName: "RequestLoginCell", bundle: nil)
        listsTableView.register(requestLoginCellNib, forCellReuseIdentifier: "RequestLoginCell")
        
        let createListCellNib = UINib(nibName: "CreateListCell", bundle: nil)
        listsTableView.register(createListCellNib, forCellReuseIdentifier: "CreateListCell")
        
        listsTableView.delegate = self
        listsTableView.dataSource = self
        
        displayTableViewSeperator()
        setupRefreshControl()
    }
    
    func displayTableViewSeperator(){
        listsTableView.separatorStyle = loggedIn ? .singleLine : .none
    }
    
    func setupRefreshControl(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(refreshLists), for: .valueChanged)
        listsTableView.addSubview(refreshControl)
    }
}

extension ShowListsViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if !loggedIn || loading || interactor!.addToList {
            return UISwipeActionsConfiguration(actions: [])
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (_, _, completionHandler) in
            self.deleteListPressed(indexPath: indexPath)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, completionHandler) in
            self.editListPressed(indexPath: indexPath)
            completionHandler(true)
        }
        
        editAction.backgroundColor = .systemGray
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

extension ShowListsViewController {
    @objc func refreshLists(){
        getLists()
    }
    
    func editListPressed(indexPath: IndexPath){
        editIndexPath = indexPath
        router?.routeToEditList(segue: nil)
    }
    
    func deleteListPressed(indexPath: IndexPath){
        startLoading()
        
        let listID = lists[indexPath.row].id
        let request = ShowLists.DeleteList.Request(indexPath: indexPath, listID: listID)
        interactor?.deleteList(request: request)
    }
    
    func createListButtonPressed(){
        router?.routeToCreateList(segue: nil)
    }
}

extension ShowListsViewController {
    func syncDeletedLists(){
        let request = ShowLists.Offline.DeletedLists.Request()
        interactor?.offlineDeletedList(request: request)
    }
    
    func syncEditedLists(){
        let request = ShowLists.Offline.EditedLists.Request()
        interactor?.offlineEditedList(request: request)
    }
}

extension ShowListsViewController {
    func startLoading() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func stopLoading(){
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
}

extension ShowListsViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !loading && lists.indices.contains(indexPath.row) {
            router?.listSelectedID = lists[indexPath.row].id
            interactor!.addToList ? router?.routeToBackListSelected(segue: nil) : router?.routeToShowList(segue: nil)
        }
    }
}

extension ShowListsViewController: UISearchBarDelegate {
    
    private func setupSearchDelegate(){
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        listSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        listSearch()
    }
    
    func listSearch(){
        let searchText = searchBar.text ?? ""
        
        if searchText.replacingOccurrences(of: " ", with: "") == "" {
            // Show all Lists
            getLists()
        } else {
            // Show filtered lists
            let request = ShowLists.SearchList.Request(query: searchText)
            interactor?.searchList(request: request)
        }
    }
}


extension ShowListsViewController: UserLoggedInProtocol {
    func loginButtonPressed(){
        router?.routeToLogin(segue: nil)
    }
    
    func userLoggedInSuccessfully(){
        getLists()
    }
}
