//
//  PeopleViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/08/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PeopleDisplayLogic: AnyObject
{
    func displaySomething(viewModel: People.Something.ViewModel)
}

class PeopleViewController: UIViewController, PeopleDisplayLogic
{
    var interactor: PeopleBusinessLogic?
    var router: (NSObjectProtocol & PeopleRoutingLogic & PeopleDataPassing)?
    
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
        let interactor = PeopleInteractor()
        let presenter = PeoplePresenter()
        let router = PeopleRouter()
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupTableView()
        doSomething()
    }
    
    var people: [PersonModel] = [
        PersonModel(id: 1, name: "Alice", message: "I have a shopping list on this app, how do I order all the shopping list and have it delivered to me."),
        PersonModel(id: 1, name: "Mary", message: "I want to know how to order some stuff, because when I added them I didn't see a button to order them."),
        PersonModel(id: 1, name: "Jane", message: "Have lost items of my list and not sure how to pay?"),
    ]
    
    @IBOutlet var peopleTableView: UITableView!
    
    func doSomething()
    {
        let request = People.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: People.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
}

extension PeopleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView(){
        let personCellNib = UINib(nibName: "PersonCell", bundle: nil)
        peopleTableView.register(personCellNib, forCellReuseIdentifier: "PersonCell")
        
        peopleTableView.delegate = self
        peopleTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configurePersonCell(tableView: tableView, indexPath: indexPath)
    }
    
    func configurePersonCell(tableView: UITableView, indexPath: IndexPath) -> PersonCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCell
        
        cell.selectionStyle = .none
        
        cell.person = people[indexPath.row]
        
        cell.configureUI()
        
        return cell
    }
}