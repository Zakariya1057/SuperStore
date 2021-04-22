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

protocol ShowRefineDisplayLogic: AnyObject
{
    func displaySelectedOptions(viewModel: ShowRefine.GetSelectedOptions.ViewModel)
    func displaySearchRefine(viewModel: ShowRefine.GetSearchRefine.ViewModel)
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
        setRefineDetails()
        
        getSearchRefine()
        setupRefineTableView()
        getSelectedOptions()
    }
    
    var refineData: [Int: RefineGroupModel] = [:]
    
    var refineGroups: RefineSearchModel = RefineSearchModel(
        sort: RefineSortGroupModel(
            name: "Sort By", selectionType: .single,
            options: [
                RefineSortOptionModel(name: "Rating - High To Low", checked: false, order: .desc, type: .rating),
                RefineSortOptionModel(name: "Rating - Low To High", checked: false, order: .asc, type: .rating),
                
                RefineSortOptionModel(name: "Price - High To Low", checked: false, order: .desc, type: .price),
                RefineSortOptionModel(name: "Price - Low To High", checked: false, order: .asc, type: .price)
            ]
        ),
        
        promotion: RefinePromotionGroupModel(name: "Offers", selectionType: .single, options: []),
        
        category: RefineCategoryGroupModel(name: "Categories", selectionType: .single, options: []),
        
        brand: RefineBrandGroupModel(name: "Brands", selectionType: .single, options: []),
        
        dietary: RefineDietaryGroupModel(
            name: "Dietary & Lifestyle", selectionType: .multiple,
            options: [
                RefineDietaryOptionModel(name: "Halal", checked: false, type: .halal),
                RefineDietaryOptionModel(name: "Vegetarian", checked: false, type: .vegetarian),
                RefineDietaryOptionModel(name: "Vegan", checked: false, type: .vegan),
                RefineDietaryOptionModel(name: "Kosher", checked: false, type: .kosher),
                
                RefineDietaryOptionModel(name: "No Peanuts", checked: false, type: .noPeanuts),
                RefineDietaryOptionModel(name: "No Shellfish", checked: false, type: .noShellfish),
                RefineDietaryOptionModel(name: "No Gluten", checked: false, type: .noGluten),
                RefineDietaryOptionModel(name: "No Milk", checked: false, type: .noMilk),
                RefineDietaryOptionModel(name: "No Lactose", checked: false, type: .noLactose),
                RefineDietaryOptionModel(name: "No Egg", checked: false, type: .noLactose),
                
                RefineDietaryOptionModel(name: "Low Salt", checked: false, type: .lowSalt),
                RefineDietaryOptionModel(name: "Low Fat", checked: false, type: .lowFat),
                
                RefineDietaryOptionModel(name: "Alcohol Free", checked: false, type: .organic),
                RefineDietaryOptionModel(name: "Organic", checked: false, type: .organic),
                RefineDietaryOptionModel(name: "No Added Sugar", checked: false, type: .noAddedSugar),
                RefineDietaryOptionModel(name: "No Milk", checked: false, type: .noCaffeine),
            ]
        )
        
    )
    
    @IBOutlet var refineTableView: UITableView!
    
    func setRefineDetails(){
        refineData[0] = refineGroups.sort
        refineData[1] = refineGroups.promotion
        refineData[2] = refineGroups.category
        refineData[3] = refineGroups.brand
        refineData[4] = refineGroups.dietary
    }
    
    func getSearchRefine(){
        let request = ShowRefine.GetSearchRefine.Request()
        interactor?.getSearchRefine(request: request)
    }
    
    func getSelectedOptions(){
        let request = ShowRefine.GetSelectedOptions.Request()
        interactor?.getSelectedOptions(request: request)
    }
    
    func displaySearchRefine(viewModel: ShowRefine.GetSearchRefine.ViewModel){
        // Add To Categories + Brands + Promotions
        let brands = viewModel.brands
        let categories = viewModel.categories
        let promotions = viewModel.promotions
        
        refineGroups.brand.options = brands
        refineGroups.category.options = categories
        refineGroups.promotion.options = promotions
    }
    
    func displaySelectedOptions(viewModel: ShowRefine.GetSelectedOptions.ViewModel) {
        let selectedRefineOptions = viewModel.selectedRefineOptions

        setRefineCheckedOptions(selectedOptions: selectedRefineOptions.sort, options: refineGroups.sort.options)
        setRefineCheckedOptions(selectedOptions: selectedRefineOptions.brand, options: refineGroups.brand.options)
        setRefineCheckedOptions(selectedOptions: selectedRefineOptions.category, options: refineGroups.category.options)
        setRefineCheckedOptions(selectedOptions: selectedRefineOptions.promotion, options: refineGroups.promotion.options)
        setRefineCheckedOptions(selectedOptions: selectedRefineOptions.dietary, options: refineGroups.dietary.options)
        
        refineTableView.reloadData()
    }
    
    func setRefineCheckedOptions(selectedOptions: [RefineOptionModel], options: [RefineOptionModel]){
        for option in options {
            for selectedOption in selectedOptions {
                if selectedOption == option {
                    option.checked = true
                }
            }
        }
    }
    
}

extension ShowRefineViewController {
    @IBAction func applyButtonPressed(_ sender: Any) {
        router?.routeToShowProductResults(segue: nil)
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        interactor?.selectedRefineOptions = SelectedRefineOptions()
        router?.routeToShowProductResults(segue: nil)
    }
}
extension ShowRefineViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return refineData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  refineData[section]!.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureRefineCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = refineTableView.dequeueReusableHeaderFooterView(withIdentifier:  "SectionHeader") as! SectionHeader
        
        let groupName = refineData[section]!.name
        header.headingLabel.text = groupName
        
        return header
    }
}

extension ShowRefineViewController {
    
    func configureRefineCell(indexPath: IndexPath) -> RefineOptionCell {
        let cell = refineTableView.dequeueReusableCell(withIdentifier: "RefineOptionCell", for: indexPath) as! RefineOptionCell
        
        let group: RefineGroupModel = refineData[indexPath.section]!
        
        cell.refineOption = group.options[indexPath.row]
        cell.configureUI()
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func setupRefineTableView(){
        let suggestionCellNib = UINib(nibName: "RefineOptionCell", bundle: nil)
        refineTableView.register(suggestionCellNib, forCellReuseIdentifier: "RefineOptionCell")
        
        let headerNib = UINib(nibName: "SectionHeader", bundle: nil)
        refineTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "SectionHeader")
        
        refineTableView.delegate = self
        refineTableView.dataSource = self
    }
}

extension ShowRefineViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        let selectedGroup = refineData[indexPath.section]!
        let selectedOption = selectedGroup.options[row]
        let checked = !selectedOption.checked
        
        if selectedGroup.selectionType == .single {
            selectedGroup.options.forEach { (option: RefineOptionModel) in
                option.checked = false
            }
        }
        
        selectedOption.checked = checked
        updateSelectedOptions(option: selectedOption)
        
        refineData[section]!.options[row].checked = checked
        
        refineTableView.reloadData()
    }
    
    func updateSelectedOptions(option: RefineOptionModel){
        let request = ShowRefine.UpdatedSelectedOptions.Request(option: option)
        interactor?.updateSelectedOptions(request: request)
    }
}
