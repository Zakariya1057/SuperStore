//
//  ShowProductViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Cosmos

protocol ShowProductDisplayLogic: class
{
    func displayProduct(viewModel: ShowProduct.GetProduct.ViewModel)
    func displayFavourite(viewModel: ShowProduct.UpdateFavourite.ViewModel)
    func displayMonitoring(viewModel: ShowProduct.UpdateMonitoring.ViewModel)
    
    func displayListItem(viewModel: ShowProduct.GetListItem.ViewModel)
    func displayCreatedListItem(viewModel: ShowProduct.CreateListItem.ViewModel)
    func displayUpdatedListItem(viewModel: ShowProduct.UpdateListItem.ViewModel)
}

class ShowProductViewController: UIViewController, ShowProductDisplayLogic
{

    var interactor: ShowProductBusinessLogic?
    var router: (NSObjectProtocol & ShowProductRoutingLogic & ShowProductDataPassing)?
    
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
        let interactor = ShowProductInteractor()
        let presenter = ShowProductPresenter()
        let router = ShowProductRouter()
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
        getProduct()
        registerReviewsTableView()
        setupGestureRecognizer()
    }
    
    // MARK: IB Outlets
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var stepperStackView: UIStackView!
    
    @IBOutlet var quantityStepper: UIStepper!
    @IBOutlet var quantityLabel: UILabel!
    
    @IBOutlet weak var reviewsStackView: UIStackView!
    @IBOutlet weak var ingredientsView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var allReviewsView: UIView!
    
    @IBOutlet weak var allReviewsButton: UIButton!
    
    @IBOutlet weak var dietaryView: UIStackView!
    @IBOutlet weak var allergenView: UIStackView!
    @IBOutlet weak var promotionView: UIView!
    @IBOutlet weak var favouriteBarItem: UIBarButtonItem!
    
    // Field Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lifeStyleLabel: UILabel!
    @IBOutlet weak var allergenLabel: UILabel!
    
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var parentRatingView: UIView!
    
    @IBOutlet weak var reviewsTableView: UITableView!
    
    @IBOutlet weak var monitorButton: UIButton!
    @IBOutlet weak var recommendedTableView: UITableView!
    @IBOutlet weak var addToListButton: UIButton!
    
    var product: ProductModel!
    var displayedProduct: ShowProduct.DisplayedProduct?

    var loading: Bool = false
    
    var scrollPosition: CGFloat = 0
    
    var reviews: [ReviewModel] = []
    var recommendedProducts: [ProductModel] = []
    
    var userSession: UserSessionWorker = UserSessionWorker()
    var loggedIn: Bool {
        return userSession.isLoggedIn()
    }
    
    func getProduct()
    {
        let request = ShowProduct.GetProduct.Request()
        interactor?.getProduct(request: request)
    }
        
    func getListItem(){
        if let listID = interactor?.selectedListID {
            let request = ShowProduct.GetListItem.Request(listID: listID, productID: product.id)
            interactor?.getListItem(request: request)
        }
    }
    
    func displayProduct(viewModel: ShowProduct.GetProduct.ViewModel)
    {
        if let error = viewModel.error {
            showError(title: "Product Error", error: error)
        } else {
            if let displayedProduct = viewModel.displayedProduct {
                
                self.product = viewModel.product
                self.displayedProduct = displayedProduct

                getListItem()
                
                updateFavouriteButton(favourite: displayedProduct.favourite)
                updateMonitorButton(monitor: displayedProduct.monitoring)
                
                imageView.downloaded(from: displayedProduct.largeImage)
                
                nameLabel.text = displayedProduct.name
                priceLabel.text = displayedProduct.price
                weightLabel.text = displayedProduct.weight
                
                if let review = displayedProduct.review {
                    reviews.append(review)
                    reviewsStackView.isHidden = false
                    allReviewsButton.isHidden = false
                    reviewsTableView.reloadData()
                } else {
                    reviewsStackView.isHidden = true
                    allReviewsButton.isHidden = true
                }
                
                ratingView.rating = displayedProduct.avgRating
                ratingView.text = "(\(displayedProduct.totalReviewsCount))"
                
                allReviewsButton.setTitle("All Reviews (\(displayedProduct.totalReviewsCount))", for: .normal)
                
                ingredientsView.isHidden = displayedProduct.ingredients.count == 0

                promotionView.isHidden = displayedProduct.promotion == nil
                
                if let promotion = displayedProduct.promotion {
                    promotionLabel.text = promotion.name
                }
                
                displayAllergen(product: displayedProduct)
                displaydietary(product: displayedProduct)
                
                recommendedProducts = displayedProduct.recommended
                recommendedTableView.reloadData()
            }
        }
    }

    func displayAllergen(product: ShowProduct.DisplayedProduct) {
        if product.allergenInfo == nil || product.allergenInfo == "" {
            allergenView.isHidden = true
        } else {
            allergenLabel.text = product.allergenInfo
        }
    }
    
    func displaydietary(product: ShowProduct.DisplayedProduct) {
        if product.dietaryInfo == nil || product.dietaryInfo == "" {
            dietaryView.isHidden = true
        } else {
            lifeStyleLabel.text = product.dietaryInfo
        }
    }
    
    
    func displayMonitoring(viewModel: ShowProduct.UpdateMonitoring.ViewModel) {
        if let error = viewModel.error {
            showError(title: "Monitor Error", error: error)
        }
    }
    
    func displayFavourite(viewModel: ShowProduct.UpdateFavourite.ViewModel) {
        if let error = viewModel.error {
            showError(title: "Favourite Error", error: error)
        }
    }
    
    func displayListItem(viewModel: ShowProduct.GetListItem.ViewModel) {
        if let listItem = viewModel.listItem {
            displayStepper()
            displayQuantity(quantity: listItem.quantity)
        }
    }
    
    func displayCreatedListItem(viewModel: ShowProduct.CreateListItem.ViewModel) {
        // Update quantity, hide add button if success
        if let error = viewModel.error {
            showError(title: "List Error", error: error)
        } else {
            if let listItem = viewModel.listItem {
                displayStepper()
                displayQuantity(quantity: listItem.quantity)
            }
        }

    }
    
    func displayUpdatedListItem(viewModel: ShowProduct.UpdateListItem.ViewModel) {
        if let error = viewModel.error {
            showError(title: "List Error", error: error)
        }
    }
}

extension ShowProductViewController {
    func displayQuantity(quantity: Int){
        quantityStepper.value = Double(quantity)
        quantityLabel.text = String(quantity)
    }
    
    func displayStepper(){
        addButton.isHidden = true
        stepperStackView.isHidden = false
    }
    
    func displayAddButton(){
        addButton.isHidden = false
        stepperStackView.isHidden = true
    }
}

extension ShowProductViewController {
    func updateMonitorButton(monitor: Bool){
        if monitor {
            monitorButton.setTitle("Monitoring Price", for: .normal)
        } else {
            monitorButton.setTitle("Monitor Price", for: .normal)
        }
    }
    
    func updateFavouriteButton(favourite: Bool) {
        let barItem:UIBarButtonItem
        
        if favourite == true {
            barItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(favouriteButtonPressed))
            barItem.image = UIImage(systemName: "star.fill")
        } else {
            barItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(favouriteButtonPressed))
            barItem.image = UIImage(systemName: "star")
        }
        
        barItem.tintColor = .systemYellow
        self.navigationItem.rightBarButtonItem = barItem
    }
}

extension ShowProductViewController {
    @IBAction func monitorButtonPressed(_ sender: Any) {
        
        if !loggedIn {
            router?.routeToLogin(segue: nil)
        } else {
            if let displayedProduct = displayedProduct {
                let monitoring: Bool = !displayedProduct.monitoring
                self.displayedProduct!.monitoring = monitoring
                
                updateMonitorButton(monitor: monitoring)
                
                let request = ShowProduct.UpdateMonitoring.Request(monitor: monitoring)
                interactor?.updateMonitoring(request: request)
            }
        }

    }
    
    @IBAction func favouriteButtonPressed(_ sender: Any) {
        
        if !loggedIn {
            router?.routeToLogin(segue: nil)
        } else {
            if let displayedProduct = displayedProduct {
                let favourite: Bool = !displayedProduct.favourite
                
                updateFavouriteButton(favourite: favourite)
                
                let request = ShowProduct.UpdateFavourite.Request(favourite: favourite)
                interactor?.updateFavourite(request: request)
                
                self.displayedProduct!.favourite = favourite
            }
        }
    }
    
    @IBAction func reviewButtonPressed(_ sender: Any) {
        loggedIn ? router?.routeToEditReview(segue: nil) : router?.routeToLogin(segue: nil)
    }
    
    @IBAction func allReviewButtonPressed(_ sender: Any) {
        router?.routeToShowReviews(segue: nil)
    }

}

//MARK: - Setup View Gestures
extension ShowProductViewController {
    
    func setupGestureRecognizer(){
        let ingredientsPressedGesture = UITapGestureRecognizer(target: self, action: #selector(ingredientsButtonPressed))
        ingredientsView.addGestureRecognizer(ingredientsPressedGesture)
        
        let descriptionPressedGesture = UITapGestureRecognizer(target: self, action: #selector(descriptionButtonPressed))
        descriptionView.addGestureRecognizer(descriptionPressedGesture)
        
        let promotionPressedGesture = UITapGestureRecognizer(target: self, action: #selector(promotionButtonPressed))
        promotionView.addGestureRecognizer(promotionPressedGesture)
    }
    
    @objc func promotionButtonPressed(){
        router?.routeToShowPromotion(segue: nil)
    }
    
    @objc func ingredientsButtonPressed(){
        router?.routeToShowIngredients(segue: nil)
    }
    
    @objc func descriptionButtonPressed(){
        router?.routeToShowDescription(segue: nil)
    }
    
}

//MARK: - Setup TableView
extension ShowProductViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == reviewsTableView ? reviews.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView == reviewsTableView ? configureReviewCell(indexPath: indexPath) : configureProductsCell(indexPath: indexPath)
    }
    
    func configureReviewCell(indexPath: IndexPath) -> ReviewCell {
        let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        
        if loading == false {
            
            if reviews.count > 0 {
                cell.review = reviews[indexPath.row]
            }
            
            cell.configureUI()
            
        } else {
            cell.startLoading()
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func configureProductsCell(indexPath: IndexPath) -> ProductsCell {
        let cell = recommendedTableView.dequeueReusableCell(withIdentifier: "ProductsCell", for: indexPath) as! ProductsCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let productElement = ProductsElementModel(products: recommendedProducts)
        productElement.productPressed = productPressed
        productElement.scrolled = scrolled
        productElement.scrollPosition = scrollPosition
        productElement.loading = loading
        
        cell.configure(model: productElement)
        
        return cell
    }
    
    func registerReviewsTableView(){
        let reviewCellNib = UINib(nibName: "ReviewCell", bundle: nil)
        reviewsTableView.register(reviewCellNib, forCellReuseIdentifier: "ReviewCell")
        
        let productsCellNib = UINib(nibName: "ProductsCell", bundle: nil)
        recommendedTableView.register(productsCellNib, forCellReuseIdentifier: "ProductsCell")
        
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        
        recommendedTableView.delegate = self
        recommendedTableView.dataSource = self
    }
}

//MARK: - CallBacks
extension ShowProductViewController {
    func scrolled(_: Int, position: CGFloat){
        scrollPosition = position
    }
    
    private func productPressed(productID: Int){
        router?.selectedProductID = productID
        router?.routeToShowProduct(segue: nil)
    }
}

extension ShowProductViewController: UserLoggedInProtocol {
    func userLoggedInSuccessfully(){
        getProduct()
    }
}

//MARK: - List Handling
extension ShowProductViewController: SelectListProtocol {

    @IBAction func addToListButtonPressed(_ sender: Any) {
        
        if !loggedIn {
            router?.routeToLogin(segue: nil)
            return
        }
        
        if interactor?.selectedListID != nil {
            displayStepper()
            
            let listID: Int = interactor!.selectedListID!
            createListItem(listID: listID)
        } else {
            router?.routeToShowLists(segue: nil)
        }
    }
    
    @IBAction func quantityStepperPressed(_ sender: UIStepper) {
        
        let quantity = Int(sender.value)
        
        if quantity == 0 {
            interactor?.selectedListID = nil
            displayAddButton()
        } else {
            displayQuantity(quantity: quantity)
            
            let listID: Int = interactor!.selectedListID!
            updateListItem(listID: listID, quantity: quantity)
        }
    }
    
    func updateListItem(listID: Int, quantity: Int){
        let request = ShowProduct.UpdateListItem.Request(listID: listID, productID: product.id, quantity: quantity)
        interactor?.updateListItem(request: request)
    }
    
    func createListItem(listID: Int){
        let request = ShowProduct.CreateListItem.Request(listID: listID, productID: product.id, parentCategoryID: product.parentCategoryID!)
        interactor?.createListItem(request: request)
    }
    
    func listSelected(listID: Int) {
        interactor?.selectedListID = listID
        createListItem(listID: listID)
    }
}

