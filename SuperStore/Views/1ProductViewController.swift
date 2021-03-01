////
////  ProductViewController.swift
////  SuperStore
////
////  Created by Zakariya Mohummed on 25/07/2020.
////  Copyright © 2020 Zakariya Mohummed. All rights reserved.
////
//
//import UIKit
//import Cosmos
//import RealmSwift
//
//class ProductViewController: UIViewController, ProductDelegate,ProductDetailsDelegate, FavouritesDelegate, ListSelectedDelegate, GroceryDelegate, ListItemsDelegate {
//
//    let realm = try! Realm()
//    
//    var product: ProductHistory? {
//        get {
//            return realm.objects(ProductHistory.self).filter("id = \(productID)").first
//        }
//    }
//    
//    @IBOutlet var addButton: UIButton!
//    @IBOutlet var stepperStackView: UIStackView!
//    
//    @IBOutlet var quantityStepper: UIStepper!
//    @IBOutlet var stepperLabel: UILabel!
//    var delegate: GroceryDelegate?
//    
//    var noDelegateFound: Bool = false
//    
//    @IBOutlet weak var reviewsStackView: UIStackView!
//    @IBOutlet weak var ingredientsView: UIView!
//    @IBOutlet weak var descriptionView: UIView!
//    @IBOutlet weak var allReviewsView: UIView!
//    
//    @IBOutlet weak var allReviewsButton: UIButton!
//    
//    @IBOutlet weak var dietaryView: UIStackView!
//    @IBOutlet weak var allergenView: UIStackView!
//    @IBOutlet weak var promotionView: UIView!
//    @IBOutlet weak var favouriteBarItem: UIBarButtonItem!
//    
//    // Field Labels
//    @IBOutlet weak var productNameLabel: UILabel!
//    @IBOutlet weak var productPriceLabel: UILabel!
//    @IBOutlet weak var productWeightLabel: UILabel!
//    @IBOutlet weak var productImageView: UIImageView!
//    @IBOutlet weak var lifeStyleLabel: UILabel!
//    @IBOutlet weak var allergenLabel: UILabel!
//    @IBOutlet weak var reviewButton: UIButton!
//    
//    @IBOutlet weak var promotionLabel: UILabel!
//    @IBOutlet weak var ratingView: CosmosView!
//    @IBOutlet weak var parentRatingView: UIView!
//    
//    @IBOutlet weak var reviewsTableView: UITableView!
//    
//    var detailType: String = ""
//    
//    var productHandler = ProductDetailsHandler()
//    
//    var productID:Int = 1
//    
//    var itemQuantity: Int?
//    
//    @IBOutlet weak var monitorButton: UIButton!
//    @IBOutlet weak var similarTableView: UITableView!
//    @IBOutlet weak var addToListButton: UIButton!
//    
//    var reviews: [ReviewModel] = []
//    var recommended: [ProductModel] = []
//    
//    var favouritesHandler = FavouritesHandler()
//    
//    var productImageLoaded: Bool = false
//    
//    var listHandler = ListItemsHandler()
//    
//    var listManager: ListManager = ListManager()
//    
//    var selectedListID: Int?
//    
//    var userHandler = UserHandler()
//    
//    var loadingViews: [UIView?] {
//        return [productNameLabel,descriptionView,ingredientsView, reviewButton,productImageView,productPriceLabel,productWeightLabel,parentRatingView,addToListButton,monitorButton,allReviewsButton, allergenLabel,promotionView,lifeStyleLabel]
//    }
//    
//    var imageLoaded: Bool = false
//    
//    var loading: Bool = true
//    
//    var notificationToken: NotificationToken?
//    
//    var loggedIn: Bool {
//        return userHandler.userSession.isLoggedIn()
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        similarTableView.register(UINib(nibName: K.Cells.ProductCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ProductCell.CellIdentifier)
//        
//        listHandler.delegate = self
//        startLoading()
//        
//        productHandler.delegate = self
//        favouritesHandler.delegate = self
//        productHandler.request(productID: productID)
//        
//        if(loggedIn){
//            favouritesHandler.request()
//        }
//        
//        similarTableView.delegate = self
//        similarTableView.dataSource = self
//        
//        let ingredients_gesture = UITapGestureRecognizer(target: self, action: #selector(showIngredients))
//        ingredientsView.addGestureRecognizer(ingredients_gesture)
//        
//        let description_gesture = UITapGestureRecognizer(target: self, action: #selector(showDescription))
//        descriptionView.addGestureRecognizer(description_gesture)
//        
//        let promotion_gesture = UITapGestureRecognizer(target: self, action: #selector(showPromotion))
//        promotionView.addGestureRecognizer(promotion_gesture)
//        
//        reviewsTableView.delegate = self
//        reviewsTableView.dataSource = self
//        
//        reviewsTableView.register(UINib(nibName: K.Cells.ReviewCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ReviewCell.CellIdentifier)
//        
//        let results = realm.objects(ProductHistory.self).filter("id = \(productID)")
//        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
//            switch changes {
//            case .initial:
//                self?.configureUI()
//                break
//            case .update(_, _, _, _):
//                self?.configureUI()
//                break
//            case .error(let error):
//                fatalError("\(error)")
//            }
//        }
//        
//        if product != nil {
//            print("Loading Product From Storage")
//            
//            for productId in product!.recommended {
//                let recommendedItem = realm.objects(ProductHistory.self).filter("id = %@", productId).first
//                if recommendedItem != nil {
//                    recommended.append(recommendedItem!.getProductModel())
//                }
//            }
//            
//            configureUI()
//        }
//        
//        if delegate == nil {
//            noDelegateFound = true
//            delegate = self
//        }
//        
//        if selectedListID != nil {
//            
//            let listItem = realm.objects(ListItemHistory.self).filter("listID = \(selectedListID!) AND productID=\(productID)").first
//            
//            if listItem != nil {
//                itemQuantity = listItem!.quantity
//                quantityStepper.value = Double(itemQuantity!)
//                stepperLabel.text = "\(itemQuantity!)"
//                showQuantityView()
//            }
//            
//        }
//        
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        notificationToken?.invalidate()
//    }
//    
//    func contentLoaded(product: ProductModel) {
//        addToHistory(product)
//        configureUI()
//    }
//    
//    func errorHandler(_ message: String) {
//        showError(message)
//    }
//    
//    func logOutUser(){
//        userHandler.userSession.viewController = self
//        userHandler.requestLogout()
//    }
//    
//    // Used by favourites delegate
//    func contentLoaded(products: [ProductModel]) {
//        //Update all favourites
//        favouritesHandler.addToFavourite(products)
//    }
//    
//    // Used by list manager
//    func contentLoaded(list: ListModel) {
//    }
//    
//    func refreshProduct() {
//        productHandler.request(productID: productID)
//    }
//    
//    func configureUI(){
//        print("Product Configure UI")
//        
////        if !userHandler.userSession.isLoggedIn() {
////            notificationToken?.invalidate()
////            return
////        }
//        
//        if(product == nil){
//            return showError("No product details found.")
//        }
//        
//        // Loading must stop before content set. Otherwise wont change label values
//        loading = false
//        stopLoading()
//        
//        let productItem = product!.getProductModel()
//        
//        productNameLabel.text = productItem.name
//        productWeightLabel.text = productItem.weight
//        
//        productPriceLabel.text = "£" + String(format: "%.2f", productItem.price)
//        
//        if !imageLoaded {
//            productImageView.downloaded(from: productItem.largeImage)
//            imageLoaded = true
//        }
//        
//        ratingView.rating = productItem.avgRating
//        ratingView.text = "(\(productItem.totalReviewsCount))"
//        
//        showFavourite()
//        showMonitoring()
//        
//        if itemQuantity != nil {
//            showQuantityView()
//            quantityStepper.value = Double(itemQuantity!)
//            stepperLabel.text = String(itemQuantity!)
//        }
//        
//        if(productItem.dietaryInfo == nil || productItem.dietaryInfo == ""){
//            dietaryView.isHidden = true
//        } else {
//            dietaryView.isHidden = false
//            lifeStyleLabel.text = productItem.dietaryInfo
//        }
//        
//        if(productItem.allergenInfo == nil || productItem.allergenInfo == ""){
//            allergenView.isHidden = true
//        } else {
//            allergenView.isHidden = false
//            allergenLabel.text = productItem.allergenInfo
//        }
//        
//        if(productItem.ingredients.count == 0){
//            ingredientsView.isHidden = true
//        } else {
//            ingredientsView.isHidden = false
//        }
//        
//        configurePromotion()
//        
//        reviews = productItem.reviews
//        let review_count = reviews.count
//        
//        if review_count != 0 {
//            reviewsTableView.reloadData()
//            allReviewsButton.setTitle("View All Reviews", for: .normal)
//            allReviewsButton.isHidden = false
//            reviewsStackView.isHidden = false
//        } else {
//            allReviewsButton.isHidden = true
//            reviewsStackView.isHidden = true
//        }
//        
//        if recommended.count > 0 {
//            similarTableView.reloadData()
//        }
//        
//    }
//    
//    func configurePromotion(){
//        if(product!.promotion == nil){
//            promotionView.isHidden = true
//        } else {
//            let promotion = product!.promotion!.getPromotionModel()
//            promotionLabel.text = promotion.name
//            promotionView.isHidden = false
//        }
//    }
//    
//    deinit {
//        notificationToken?.invalidate()
//    }
//    
//    @objc func showIngredients(){
//        detailType = "ingredients"
//        self.performSegue(withIdentifier: "showProductDetails", sender: self)
//    }
//    
//    @objc func showDescription(){
//        detailType = "description"
//        self.performSegue(withIdentifier: "showProductDetails", sender: self)
//    }
//    
//    @objc func showPromotion(){
//        self.performSegue(withIdentifier: "showProductPromotion", sender: self)
//    }
//    
//    @IBAction func monitorPressed(_ sender: Any) {
//        
//        if !loggedIn {
//            return showLoginPage()
//        }
//        
//        try? realm.write({
//            product!.monitoring = !product!.monitoring
//            product!.updatedAt = Date()
//        })
//        
//        productHandler.requestMonitor(productID: productID, userData: ["monitor": String(product!.monitoring)])
//        showMonitoring()
//    }
//    
//    @IBAction func favouritePressed(_ sender: Any) {
//        
//        if !loggedIn {
//            return showLoginPage()
//        }
//        
//        if product == nil {
//            return
//        }
//        
//        try! realm.write() {
//            product!.favourite = !product!.favourite
//            product!.updatedAt = Date()
//        }
//        
//        favouritesHandler.update(productID: productID, favourite: product!.favourite)
//        showFavourite()
//    }
//    
//    func showFavourite(){
//        
//        if(product != nil){
//            
//            let barItem:UIBarButtonItem
//            
//            if product!.favourite == true {
//                barItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(favouritePressed))
//                barItem.image = UIImage(systemName: "star.fill")
//            } else {
//                barItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(favouritePressed))
//                barItem.image = UIImage(systemName: "star")
//            }
//            
//            barItem.tintColor = .systemYellow
//            self.navigationItem.rightBarButtonItem = barItem
//            
//        }
//        
//        
//    }
//    
//    func showMonitoring(){
//        if(product != nil){
//            
//            if product!.monitoring == true {
//                monitorButton.setTitle("Unmonitor Price", for: .normal)
//            } else {
//                monitorButton.setTitle("Monitor Price", for: .normal)
//            }
//            
//        }
//        
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "showProductDetails" {
//            
//            let destinationVC = segue.destination as! ProductDetailsViewController
//            
//            if(detailType == "ingredients"){
//                destinationVC.header_text = "Ingredients"
//                destinationVC.list = product!.getProductModel().ingredients
//            } else if(detailType == "description"){
//                destinationVC.header_text = "Description"
//                destinationVC.list = [ product!.getProductModel().description ?? "" ]
//            }
//            
//        } else if segue.identifier == "productToReviews" {
//            let destinationVC = segue.destination as! ReviewsViewController
//            destinationVC.productID = productID
//        }  else if segue.identifier == "showProductPromotion" {
//            let destinationVC = segue.destination as! PromotionViewController
//            
//            if noDelegateFound == false {
//                destinationVC.delegate = self.delegate
//            }
//            
//            destinationVC.promotionID = product!.promotion!.getPromotionModel().id
//        } else if segue.identifier == "productToCreateReview" {
//            let destinationVC = segue.destination as! ReviewViewController
//            destinationVC.productID = product!.id
//        }
//        
//    }
//    
//}
//
//extension ProductViewController: UITableViewDataSource, UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if tableView == similarTableView {
//            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.ProductCell.CellIdentifier, for: indexPath) as! ProductsCell
//            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//            cell.loading = self.loading
////            cell.configure(withModel: ProductElement(title: "Products You May Like", delegate: self, scrollDelegate: nil, products: recommended))
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.ReviewCell.CellIdentifier , for: indexPath) as! ReviewTableViewCell
//            
//            if loading == false {
//                
//                if reviews.count > 0 {
//                    cell.review = reviews[0]
//                }
//                
//                cell.configureUI()
//                
//            } else {
//                cell.startLoading()
//            }
//            
//            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//            
//            return cell
//        }
//        
//    }
//    
//    func showProduct(productID: Int) {
//        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
//        destinationVC.productID = productID
//        
//        if noDelegateFound == false {
//            destinationVC.delegate = self.delegate
//        }
//        
//        self.navigationController?.pushViewController(destinationVC, animated: true)
//    }
//    
//    func startLoading(){
//        for item in loadingViews {
//            if item != nil {
//                item!.isSkeletonable = true
//                item!.showAnimatedGradientSkeleton()
//            }
//        }
//    }
//    
//    func stopLoading(){
//        for item in loadingViews {
//            if item != nil {
//                item!.hideSkeleton()
//            }
//        }
//    }
//    
//    func showError(_ error: String){
//        let alert = UIAlertController(title: "Product Error", message: error, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//        self.present(alert, animated: true)
//    }
//    
//    
//}
//
//extension ProductViewController {
//    
//    @IBAction func reviewPressed(_ sender: Any) {
//        if !loggedIn {
//            return showLoginPage()
//        }
//        
//        self.performSegue(withIdentifier: "productToCreateReview", sender: self)
//    }
//    
//    
//    @IBAction func addPressed(_ sender: Any) {
//        
//        if !loggedIn {
//            return showLoginPage()
//        }
//        
//        if noDelegateFound == false {
//            showQuantityView()
//        }
//        self.delegate?.addToList(product!.getProductModel(), cell: nil)
//    }
//    
//    @IBAction func stepperPressed(_ sender: UIStepper) {
//        let quantity = sender.value
//
//        stepperLabel.text = String(format: "%.0f", quantity)
//        delegate?.updateQuantity(product!.getProductModel())
//
//        if(quantity == 0){
//            showAddButtonView()
//            quantityStepper.value = 1
//            stepperLabel.text = "1"
//        }
//    }
//    
//    func showAddButtonView(){
//        print("Show Add Button")
//        stepperStackView.isHidden = true
//        selectedListID = nil
//        addButton.isHidden = false
//    }
//    
//    func showQuantityView(){
//        print("Show Quantity View")
//        stepperStackView.isHidden = false
//        addButton.isHidden = true
//    }
//    
//    
//    func addToList(_ productItem: ProductModel, cell: GroceryTableViewCell?){
//        
//        if selectedListID != nil {
//            let item = listManager.addProductToList(listID: selectedListID!, product: product!.getProductModel())
//            quantityStepper.value = Double(item.quantity)
//            stepperLabel.text = "\(item.quantity)"
//            itemQuantity = item.quantity
//            showQuantityView()
//        } else {
//            let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "listsViewController"))! as! ListsViewController
//            destinationVC.delegate = self
//            
//            self.present(destinationVC, animated: true)
//        }
//        
//        print("Adding To List")
//    }
//    
//    
//    func listSelected(listID: Int) {
//        self.selectedListID = listID
//        
//        let item = listManager.addProductToList(listID: listID, product: product!.getProductModel())
//        quantityStepper.value = Double(item.quantity)
//        stepperLabel.text = "\(item.quantity)"
//        
//        listHandler.create(listID: listID, listData: ["product_id": String(product!.id)])
//        
//        showQuantityView()
//    }
//    
//    func updateQuantity(_ productItem: ProductModel) {
//        
//        if selectedListID != nil {
//            
//            productItem.quantity = Int(quantityStepper.value)
//            
//            let data:[String: String] = [
//                "product_id": String(productItem.id),
//                "quantity": String(productItem.quantity),
//                "ticked_off": "false"
//            ]
//            
//            listManager.updateProduct(listID: selectedListID!, product: productItem)
//            
//            listHandler.update(listID:selectedListID!, listData: data)
//
//        }
//        
//    }
//    
//    func showGroceryItem(_ productID: Int) {
//        
//    }
//    
//}
//
//extension ProductViewController {
//    func addToHistory(_ productItem: ProductModel){
//        
//        self.recommended = productItem.recommended
//        
//        try! realm.write() {
//            
//            if product != nil {
//                print("Updating Product")
//                
//                product!.price = productItem.price
//                product!.brand = productItem.brand ?? ""
//                product!.avgRating = productItem.avgRating
//                product!.productDescription = productItem.description
//                product!.smallImage = productItem.smallImage
//                product!.largeImage = productItem.largeImage
//                
//                product!.favourite = productItem.favourite ?? false
//                product!.monitoring = productItem.monitoring ?? false
//                
//                product!.parentCategoryId = productItem.parentCategoryId!
//                product!.parentCategoryName = productItem.parentCategoryName
//                
//                product!.weight = productItem.weight
//                product!.allergenInfo = productItem.allergenInfo
//                product!.dietaryInfo = productItem.dietaryInfo
//                product!.storage = productItem.storage
//                
//                productItem.ingredients.forEach({product!.ingredients.append($0)})
//                
//                product!.recommended = List<Int>()
//                
//                if productItem.promotion != nil {
//                    configurePromotion()
//                    product!.promotion = productItem.promotion!.getRealmObject()
//                } else {
//                    product!.promotion = nil
//                }
//                
//                for review in productItem.reviews {
//                    let reviewHistory = realm.objects(ReviewHistory.self).filter("id = \(review.id)").first
//                    if(reviewHistory == nil){
//                        product!.reviews.append( review.getRealmObject() )
//                    }
//                }
//                
//                for recommendedProduct in productItem.recommended {
//                    product!.recommended.append( recommendedProduct.id )
//                }
//                
//                let listItems = realm.objects(ListItemHistory.self).filter("productID = \(productItem.id)")
//                for item in listItems {
//                    item.image = productItem.largeImage
//                    item.promotion = productItem.promotion?.getRealmObject()
//                    item.price = productItem.price
//                }
//                
//            } else {
//                let productObject = productItem.getRealmObject()
//                productObject.favourite = productItem.favourite!
//                
//                realm.add(productObject)
//                
//                for product in productItem.recommended {
//                    let productHistory = realm.objects(ProductHistory.self).filter("id = \(product.id)").first
//                    
//                    if productHistory == nil {
//                        realm.add(product.getRealmObject())
//                    }
//                    
//                }
//                
//            }
//            
//            for product in productItem.recommended {
//                let productHistory = realm.objects(ProductHistory.self).filter("id = \(product.id)").first
//                
//                if productHistory == nil {
//                    realm.add(product.getRealmObject())
//                }
//                
//            }
//            
//        }
//        
//    }
//    
//}
//
//extension ProductViewController {
//    func showLoginPage(){
//        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "loginViewController"))! as! LoginViewController
//        self.navigationController?.pushViewController(destinationVC, animated: true)
//    }
//}