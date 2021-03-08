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

protocol ShowListsDisplayLogic: class
{
    func displayLists(viewModel: ShowLists.GetLists.ViewModel)
    func displayListDeleted(viewModel: ShowLists.DeleteList.ViewModel)
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
        getLists()
    }
    
    var lists: [ListModel] = []
    
    var editIndexPath: IndexPath?
    
    let spinner: SpinnerViewController = SpinnerViewController()
    var refreshControl = UIRefreshControl()
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var listsTableView: UITableView!
    
    var userSession: UserSessionWorker = UserSessionWorker()
    var loggedIn: Bool {
        return userSession.isLoggedIn()
    }

    func getLists()
    {
        if loggedIn {
            let request = ShowLists.GetLists.Request()
            interactor?.getLists(request: request)
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
            showError(title: "Lists Error", error: error)
        } else {
            lists = viewModel.lists
            listsTableView.reloadData()
        }
    }
    
    func displayListDeleted(viewModel: ShowLists.DeleteList.ViewModel){
        stopLoading()
        
        if let error = viewModel.error {
            showError(title: "Delete Error", error: error)
        } else {
            lists.remove(at: viewModel.indexPath.row)
            listsTableView.deleteRows(at: [viewModel.indexPath], with: .left)
        }
    }
}

extension ShowListsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loggedIn ? lists.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return loggedIn ? configureProductCell(indexPath: indexPath) : configureRequestLoginCell(indexPath: indexPath)
    }
    
    func configureRequestLoginCell(indexPath: IndexPath) -> RequestLoginCell {
        let cell = listsTableView.dequeueReusableCell(withIdentifier: "RequestLoginCell", for: indexPath) as! RequestLoginCell
        
        cell.titleLabel.text = "Create List"
        cell.descriptionLabel.text = "Login to create a shopping list, tick items of your list and get notified when product prices change."
        
        cell.loginButtonPressed = loginButtonPressed
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func configureProductCell(indexPath: IndexPath) -> ListCell {
        let cell = listsTableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        
        cell.list = lists[indexPath.row]
        cell.configureUI()
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func setupListsTableView(){
        let listCellNib = UINib(nibName: "ListCell", bundle: nil)
        listsTableView.register(listCellNib, forCellReuseIdentifier: "ListCell")
        
        let requestLoginCellNib = UINib(nibName: "RequestLoginCell", bundle: nil)
        listsTableView.register(requestLoginCellNib, forCellReuseIdentifier: "RequestLoginCell")
        
        listsTableView.delegate = self
        listsTableView.dataSource = self
        
        setupRefreshControl()
    }
    
    func setupRefreshControl(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(refreshLists), for: .valueChanged)
        listsTableView.addSubview(refreshControl)
    }
}

extension ShowListsViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
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
        router?.routeToShowList(segue: nil)
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
