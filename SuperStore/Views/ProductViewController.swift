//
//  ProductViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import Cosmos
import RealmSwift

class ProductViewController: UIViewController, ProductDelegate,ProductDetailsDelegate, FavouritesDelegate, ListSelectedDelegate, GroceryDelegate {

    let realm = try! Realm()
    
    var product: ProductHistory? {
        get {
            return realm.objects(ProductHistory.self).filter("id = \(product_id)").first
        }
    }
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var stepperStackView: UIStackView!
    
    @IBOutlet var quantityStepper: UIStepper!
    @IBOutlet var stepperLabel: UILabel!
    var delegate: GroceryDelegate?
    
    var add_to_list_product_id: Int?
    var noDelegateFound: Bool = false
    
    @IBOutlet var stepperPressed: UIStepper!
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
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productWeightLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var lifeStyleLabel: UILabel!
    @IBOutlet weak var allergenLabel: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var parentRatingView: UIView!
    
    @IBOutlet weak var reviewsTableView: UITableView!
    
    var details_type: String = ""
    
    var productHandler = ProductDetailsHandler()
    
    var product_id:Int = 1
    
    var itemQuantity: Int?
    
    @IBOutlet weak var monitorButton: UIButton!
    @IBOutlet weak var similarTableView: UITableView!
    @IBOutlet weak var addToListButton: UIButton!
    
    var reviews: [ReviewModel] = []
    var recommended: [ProductModel] = []
    
    var favouritesHandler = FavouritesHandler()
    
    var productImageLoaded: Bool = false
    
    var listHandler = ListItemsHandler()
    
    var listManager: ListManager = ListManager()
    
    var selected_product_id:Int?
    var selectedListId: Int?
    
    var userHandler = UserHandler()
    
    var loadingViews: [UIView?] {
        return [productNameLabel,descriptionView,ingredientsView, reviewButton,productImageView,productPriceLabel,productWeightLabel,parentRatingView,addToListButton,monitorButton,allReviewsButton, allergenLabel,promotionView,lifeStyleLabel]
    }
    
    var imageLoaded: Bool = false
    
    var loading: Bool = true
    
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        similarTableView.register(UINib(nibName: K.Cells.ProductCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ProductCell.CellIdentifier)
        
        startLoading()
        
        productHandler.delegate = self
        favouritesHandler.delegate = self
        productHandler.request(product_id: product_id)

        similarTableView.delegate = self
        similarTableView.dataSource = self
        
        let ingredients_gesture = UITapGestureRecognizer(target: self, action: #selector(showIngredients))
        ingredientsView.addGestureRecognizer(ingredients_gesture)
        
        let description_gesture = UITapGestureRecognizer(target: self, action: #selector(showDescription))
        descriptionView.addGestureRecognizer(description_gesture)
        
        let promotion_gesture = UITapGestureRecognizer(target: self, action: #selector(showPromotion))
        promotionView.addGestureRecognizer(promotion_gesture)
        
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        
        reviewsTableView.register(UINib(nibName: K.Cells.ReviewCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ReviewCell.CellIdentifier)
        
        let results = realm.objects(ProductHistory.self).filter("id = \(product_id)")
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
                case .initial:
                    // Results are now populated and can be accessed without blocking the UI
                    self?.configureUI()
                    break
            case .update(_, _, _, _):
                    self?.configureUI()
                    break
                case .error(let error):
                    fatalError("\(error)")
            }
        }
        
        if product != nil {
            print("Loading Product From Storage")
            
            for productId in product!.recommended {
                let recommendedItem = realm.objects(ProductHistory.self).filter("id = %@", productId).first
                if recommendedItem != nil {
                    recommended.append(recommendedItem!.getProductModel())
                }
            }
            
            configureUI()
        }
        
        if delegate == nil {
            noDelegateFound = true
            delegate = self
        }
        
        if selectedListId != nil {
            
            let listItem = realm.objects(ListItemHistory.self).filter("list_id = \(selectedListId!) AND product_id=\(product_id)").first
            
            if listItem != nil {
                itemQuantity = listItem!.quantity
                quantityStepper.value = Double(itemQuantity!)
                stepperLabel.text = "\(itemQuantity!)"
                showQuantityView()
            }

        }
       
    }
    
    func contentLoaded(product: ProductModel) {
        addToHistory(product)
        configureUI()
    }
    
    func errorHandler(_ message: String) {
        showError(message)
    }
    
    func logOutUser(){
        userHandler.userSession.viewController = self
        userHandler.requestLogout()
    }
    
    // Used by favourites delegate
    func contentLoaded(products: [ProductModel]) {
        
    }
    
    func refreshProduct() {
        productHandler.request(product_id: product_id)
    }
    
    func configureUI(){
        // Loading must stop before content set. Otherwise wont change label values
        loading = false
        stopLoading()
        
        let productItem = product!.getProductModel()

        productNameLabel.text = productItem.name
        productWeightLabel.text = productItem.weight

        productPriceLabel.text = "£" + String(format: "%.2f", productItem.price)
        
        if !imageLoaded {
            productImageView.downloaded(from: productItem.largeImage)
            imageLoaded = true
        }

        ratingView.rating = productItem.avgRating
        ratingView.text = "(\(productItem.totalReviewsCount))"

        showFavourite()
        showMonitoring()

        if itemQuantity != nil {
            showQuantityView()
            quantityStepper.value = Double(itemQuantity!)
            stepperLabel.text = String(itemQuantity!)
        }
        
        if(productItem.dietary_info == nil || productItem.dietary_info == ""){
            dietaryView.isHidden = true
        } else {
            dietaryView.isHidden = false
            lifeStyleLabel.text = productItem.dietary_info
        }

        if(productItem.allergen_info == nil || productItem.allergen_info == ""){
            allergenView.isHidden = true
        } else {
            allergenView.isHidden = false
            allergenLabel.text = productItem.allergen_info
        }

        configurePromotion()

        reviews = productItem.reviews
        let review_count = reviews.count
        
        if review_count != 0 {
            reviewsTableView.reloadData()
            allReviewsButton.setTitle("View All Reviews", for: .normal)
            allReviewsButton.isHidden = false
            reviewsStackView.isHidden = false
        } else {
            allReviewsButton.isHidden = true
            reviewsStackView.isHidden = true
        }

        if recommended.count > 0 {
            similarTableView.reloadData()
        }
        
        
    }
    
    func configurePromotion(){
        if(product!.promotion == nil){
            promotionView.isHidden = true
        } else {
            let promotion = product!.promotion!.getPromotionModel()
            promotionLabel.text = promotion.name
            promotionView.isHidden = false
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    @objc func showIngredients(){
        details_type = "ingredients"
        self.performSegue(withIdentifier: "showProductDetails", sender: self)
    }
    
    @objc func showDescription(){
        details_type = "description"
        self.performSegue(withIdentifier: "showProductDetails", sender: self)
    }
    
    @objc func showPromotion(){
        self.performSegue(withIdentifier: "showProductPromotion", sender: self)
    }
    
    @IBAction func monitorPressed(_ sender: Any) {
        try? realm.write({
            product!.monitoring = !product!.monitoring
            product!.updated_at = Date()
        })
        
        productHandler.requestMonitor(product_id: product_id, userData: ["monitor": String(product!.monitoring)])
        showMonitoring()
    }
    
    @IBAction func favouritePressed(_ sender: Any) {
        
        if product == nil {
            return
        }
        
        try! realm.write() {
            product!.favourite = !product!.favourite
            product!.updated_at = Date()
        }
       
        favouritesHandler.update(product_id: product_id, favourite: product!.favourite)
        showFavourite()
    }
    
    func showFavourite(){
        
        if(product != nil){
         
            let barItem:UIBarButtonItem
            
            if product!.favourite == true {
                barItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(favouritePressed))
                barItem.image = UIImage(systemName: "star.fill")
            } else {
                barItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(favouritePressed))
                barItem.image = UIImage(systemName: "star")
            }
            
            barItem.tintColor = .systemYellow
            self.navigationItem.rightBarButtonItem = barItem
            
        }

        
    }
    
    func showMonitoring(){
        if(product != nil){
            
            if product!.monitoring == true {
                monitorButton.setTitle("Unmonitor Price", for: .normal)
            } else {
                monitorButton.setTitle("Monitor Price", for: .normal)
            }
            
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        if segue.identifier == "showProductDetails" {
            
            let destinationVC = segue.destination as! ProductDetailsViewController
            
            if(details_type == "ingredients"){
                destinationVC.header_text = "Ingredients"
                destinationVC.list = product!.getProductModel().ingredients
            } else if(details_type == "description"){
                destinationVC.header_text = "Description"
                destinationVC.list = [ product!.getProductModel().description ?? "" ]
            }
            
        } else if segue.identifier == "productToReviews" {
            let destinationVC = segue.destination as! ReviewsViewController
            destinationVC.product_id = product_id
        }  else if segue.identifier == "showProductPromotion" {
            let destinationVC = segue.destination as! PromotionViewController
            
            if noDelegateFound == false {
                destinationVC.delegate = self.delegate
            }
            
            destinationVC.promotion_id = product!.promotion!.getPromotionModel().id
        } else if segue.identifier == "productToCreateReview" {
            let destinationVC = segue.destination as! ReviewViewController
            destinationVC.product_id = product!.id
        }

    }

}

extension ProductViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == similarTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.ProductCell.CellIdentifier, for: indexPath) as! ProductTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.loading = self.loading
            cell.configure(withModel: ProductElement(title: "Products You May Like", delegate: self, scrollDelegate: nil, products: recommended))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.ReviewCell.CellIdentifier , for: indexPath) as! ReviewTableViewCell
            
            if loading == false {
                
                if reviews.count > 0 {
                    cell.review = reviews[0]
                }
                
                cell.configureUI()
                
            } else {
                cell.startLoading()
            }

            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        }

    }
    
    func showProduct(product_id: Int) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        destinationVC.product_id = product_id
        
        if noDelegateFound == false {
            destinationVC.delegate = self.delegate
        }
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func startLoading(){
        for item in loadingViews {
            if item != nil {
                item!.isSkeletonable = true
                item!.showAnimatedGradientSkeleton()
            }
        }
    }
    
    func stopLoading(){
        for item in loadingViews {
            if item != nil {
                item!.hideSkeleton()
            }
        }
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Product Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
}

extension ProductViewController {

    @IBAction func addPressed(_ sender: Any) {
        if noDelegateFound == false {
            showQuantityView()
        }
        
        self.delegate?.addToList(product!.getProductModel(), cell: nil)
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {

        let quantity = sender.value
        stepperLabel.text = String(format: "%.0f", quantity)
        
        quantityStepper.value = quantity
        delegate?.updateQuantity(product!.getProductModel())
        
        if(quantity == 0){
            showAddButtonView()
            
            quantityStepper.value = 1
            stepperLabel.text = "1"
        }
        
    }
    
    func showAddButtonView(){
        print("Show Add Button")
        stepperStackView.isHidden = true
        selectedListId = nil
        addButton.isHidden = false
    }
    
    func showQuantityView(){
        print("Show Quantity View")
        stepperStackView.isHidden = false
        addButton.isHidden = true
    }
    
    
    func addToList(_ productItem: ProductModel, cell: GroceryTableViewCell?){
        
        if selectedListId != nil {
            let item = listManager.addProductToList(listId: selectedListId!, product: product!.getProductModel())
            quantityStepper.value = Double(item.quantity)
            stepperLabel.text = "\(item.quantity)"
            showQuantityView()
        } else {
            let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "listsViewController"))! as! ListsViewController
            destinationVC.delegate = self
            
            self.present(destinationVC, animated: true)
            self.add_to_list_product_id = product!.id
        }
        
        print("Adding To List")
    }
    
    
    func listSelected(list_id: Int) {
        self.selectedListId = list_id

        let item = listManager.addProductToList(listId: list_id, product: product!.getProductModel())
        quantityStepper.value = Double(item.quantity)
        stepperLabel.text = "\(item.quantity)"
        
        listHandler.create(list_id: list_id, list_data: ["product_id": String(add_to_list_product_id!)])
        
        showQuantityView()
    }
    
    func updateQuantity(_ product: ProductModel) {

        if selectedListId != nil {
         
            let data:[String: String] = [
                "product_id": String(product.id),
                "quantity": String(product.quantity),
                "ticked_off": "false"
            ]
            
            listManager.updateProduct(listId: selectedListId!, product: product)
            
            listHandler.update(listId:selectedListId!, listData: data)
            
        }
       
    }
    
    func showGroceryItem(_ product_id: Int) {
        
    }
    
}

extension ProductViewController {
    func addToHistory(_ productItem: ProductModel){
        
        self.recommended = productItem.recommended
        
        try! realm.write() {
            
            if product != nil {
                print("Updating Product")
                
                realm.delete( realm.objects(ReviewHistory.self).filter("product_id = \(productItem.id)") )
                
                product!.brand = productItem.brand ?? ""
                product!.avgRating = productItem.avgRating
                product!.product_description = productItem.description
                product!.smallImage = productItem.smallImage
                product!.largeImage = productItem.largeImage
                
                product!.favourite = productItem.favourite!
                product!.monitoring = productItem.monitoring!
                
                product!.parentCategoryId = productItem.parentCategoryId!
                product!.parentCategoryName = productItem.parentCategoryName
                
                product!.weight = productItem.weight
                product!.allergen_info = productItem.allergen_info
                product!.dietary_info = productItem.dietary_info
                product!.storage = productItem.storage
                
                productItem.ingredients.forEach({product!.ingredients.append($0)})
                
                product!.recommended = List<Int>()
                
                if productItem.promotion != nil {
                    configurePromotion()
                    product!.promotion = productItem.promotion!.getRealmObject()
                } else {
                    product!.promotion = nil
                }
               
                
                productItem.reviews.forEach({ product!.reviews.append( $0.getRealmObject()) })
                
                for recommendedProduct in productItem.recommended {
                    product!.recommended.append( recommendedProduct.id )
                }
                
            } else {
                let productObject = productItem.getRealmObject()
                productObject.favourite = productItem.favourite!
                
                realm.add(productObject)
                
                for product in productItem.recommended {
                    let productHistory = realm.objects(ProductHistory.self).filter("id = \(product.id)").first
                    
                    if productHistory == nil {
                        realm.add(product.getRealmObject())
                    }
                    
                }
                
            }
            
            for product in productItem.recommended {
                let productHistory = realm.objects(ProductHistory.self).filter("id = \(product.id)").first
                
                if productHistory == nil {
                    realm.add(product.getRealmObject())
                }
                
            }

        }
        
    }
    
}
