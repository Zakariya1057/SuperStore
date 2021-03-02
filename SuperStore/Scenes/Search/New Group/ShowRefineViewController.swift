//
//  ShowRefineViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowRefineDisplayLogic: class
{
    func displaySomething(viewModel: ShowRefine.Something.ViewModel)
}

class ShowRefineViewController: UIViewController, ShowRefineDisplayLogic
{
    var interactor: ShowRefineBusinessLogic?
    var router: (NSObjectProtocol & ShowRefineRoutingLogic & ShowRefineDataPassing)?
    
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
        let interactor = ShowRefineInteractor()
        let presenter = ShowRefinePresenter()
        let router = ShowRefineRouter()
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
        setupRefineTableView()
    }
    
    // MARK: Do something
    
    var selectedOptions: [RefineOptionModel] = []
    
    var refineGroups: [RefineGroupModel] = [
        RefineSortByModel(name: "Sort By", options: [RefineSortModel(name: "Rating - High To Low", checked: false, order: .desc, type: .rating)])
    ]
    
    @IBOutlet var refineTableView: UITableView!
    //@IBOutlet weak var nameTextField: UITextField!

    func displaySomething(viewModel: ShowRefine.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
}

extension ShowRefineViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refineGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureRefineCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = refineTableView.cellForRow(at: indexPath) as! RefineOptionCell
        let checked: Bool = !row.refineOption!.checked
        
        if(checked){
            
        }
        
        row.refineOption!.checked = checked
        row.showCheckBox()
    }
    
    func configureRefineCell(indexPath: IndexPath) -> RefineOptionCell {
        let cell = refineTableView.dequeueReusableCell(withIdentifier: "RefineOptionCell", for: indexPath) as! RefineOptionCell
        
        cell.refineOption = refineGroups[indexPath.section].options[indexPath.row]
        print(cell.refineOption )
        cell.configureUI()
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func setupRefineTableView(){
        let suggestionCellNib = UINib(nibName: "RefineOptionCell", bundle: nil)
        refineTableView.register(suggestionCellNib, forCellReuseIdentifier: "RefineOptionCell")
        
        refineTableView.delegate = self
        refineTableView.dataSource = self
    }
}

extension ShowRefineViewController {
    // When checkbox selected. Update our local database. At the end pass data back
    
}
