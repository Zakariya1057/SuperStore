//
//  ShowDescriptionViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowDescriptionDisplayLogic: AnyObject
{
    func displayDescription(viewModel: ShowDescription.GetDescription.ViewModel)
}

class ShowDescriptionViewController: UIViewController, ShowDescriptionDisplayLogic
{
    var interactor: ShowDescriptionBusinessLogic?
    var router: (NSObjectProtocol & ShowDescriptionRoutingLogic & ShowDescriptionDataPassing)?
    
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
        let interactor = ShowDescriptionInteractor()
        let presenter = ShowDescriptionPresenter()
        let router = ShowDescriptionRouter()
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
        getDescription()
    }
    

    
    @IBOutlet var descriptionTableView: UITableView!
    var productDescription: String = ""
    
    func getDescription()
    {
        let request = ShowDescription.GetDescription.Request()
        interactor?.doSomething(request: request)
    }
    
    func displayDescription(viewModel: ShowDescription.GetDescription.ViewModel)
    {
        productDescription = viewModel.description
        descriptionTableView.reloadData()
    }
}

extension ShowDescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView(){
        descriptionTableView.delegate = self
        descriptionTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = productDescription
        cell.textLabel?.numberOfLines = 1000
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
}
