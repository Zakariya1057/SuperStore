//
//  ProductViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import Cosmos

class ProductViewController: UIViewController, ProductDelegate,ProductDetailsDelegate, FavouritesDelegate, ListSelectedDelegate, GroceryDelegate {

    @IBOutlet var addButton: UIButton!
    @IBOutlet var stepperStackView: UIStackView!
    
    @IBOutlet var quantityStepper: UIStepper!
    @IBOutlet var stepperLabel: UILabel!
    var delegate:GroceryDelegate?
    
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
//    @IBOutlet weak var promotionExpiryView: UIView!
    @IBOutlet weak var favouriteBarItem: UIBarButtonItem!
    
    //Field Labels
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productWeightLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var lifeStyleLabel: UILabel!
    @IBOutlet weak var allergenLabel: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    
//    @IBOutlet weak var promotionExpiryLabel: UILabel!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var parentRatingView: UIView!
    
    @IBOutlet weak var reviewsTableView: UITableView!
    var product: ProductDetailsModel?
    
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
    
    var listHandler = ListItemsHandler()
    
    var selected_product_id:Int?
    var selected_list_id: Int?
    
    var loadingViews: [UIView?] {
        return [productNameLabel,descriptionView,ingredientsView, reviewButton,productImageView,productPriceLabel,productWeightLabel,parentRatingView,addToListButton,monitorButton,allReviewsButton, allergenLabel,promotionView,lifeStyleLabel]
    }
    
    var loading: Bool = true
    
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
        
        if delegate == nil {
            noDelegateFound = true
            delegate = self
        }
       
    }
    
    func errorHandler(_ message: String) {
        showError(message)
    }
    
    func contentLoaded(product: ProductDetailsModel) {
        self.product = product
        
        loading = false
        stopLoading()
        
        productNameLabel.text = product.name
        productWeightLabel.text = product.weight

        productPriceLabel.text = "£" + String(format: "%.2f", product.price)
        productImageView.downloaded(from: product.image)

        ratingView.rating = product.avg_rating!
        ratingView.text = "(\(product.total_reviews_count!))"

        showFavourite()

        if itemQuantity != nil {
            showQuantityView()
            product.quantity = itemQuantity!
            quantityStepper.value = Double(itemQuantity!)
            stepperLabel.text = String(itemQuantity!)
        }
        
        if(product.dietary_info == nil || product.dietary_info == ""){
            dietaryView.removeFromSuperview()
        } else {
            lifeStyleLabel.text = product.dietary_info
        }

        if(product.allergen_info == nil || product.allergen_info == ""){
            allergenView.removeFromSuperview()
        } else {
            allergenLabel.text = product.allergen_info
        }

        if(product.discount == nil){
            promotionView.removeFromSuperview()
        } else {
            let promotion = product.discount!
            promotionLabel.text = promotion.name
        }

        reviews = product.reviews
        let review_count = reviews.count

        if review_count != 0 {
            reviewsTableView.reloadData()
            allReviewsButton.setTitle("View All Reviews", for: .normal)
        } else {
            allReviewsButton.removeFromSuperview()
            reviewsStackView.removeFromSuperview()
        }

        if product.recommended.count > 0 {
            recommended = product.recommended
            similarTableView.reloadData()
        }
        
    }
    
    func refreshProduct() {
        productHandler.request(product_id: product_id)
    }
    
    func contentLoaded(products: [ProductModel]) {
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
    
    @IBAction func favouritePressed(_ sender: Any) {
        
        if product == nil {
            return
        }
        
        product!.favourite = !product!.favourite
        favouritesHandler.update(product_id: product_id, favourite: product!.favourite)
        showFavourite()
    }
    
    func showFavourite(){
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        if segue.identifier == "showProductDetails" {
            
            let destinationVC = segue.destination as! ProductDetailsViewController
            
            if(details_type == "ingredients"){
                destinationVC.header_text = "Ingredients"
                destinationVC.list = product!.ingredients
            } else if(details_type == "description"){
                destinationVC.header_text = "Description"
                destinationVC.list = [ product!.description ?? "" ]
            }
            
        } else if segue.identifier == "productToReviews" {
            let destinationVC = segue.destination as! ReviewsViewController
            destinationVC.product_id = product_id
        }  else if segue.identifier == "showProductPromotion" {
            let destinationVC = segue.destination as! PromotionViewController
            
            if noDelegateFound == false {
                destinationVC.delegate = self.delegate
            }
            
            destinationVC.promotion_id = product!.discount!.id
        } else if segue.identifier == "productToCreateReview" {
            let destinationVC = segue.destination as! ReviewViewController
            destinationVC.product = product!
        }

    }

}

extension ProductViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading == true {
            return 1
        }
        
        if tableView == similarTableView {
            return 1
        } else {
            return reviews.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == similarTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.ProductCell.CellIdentifier, for: indexPath) as! ProductTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.configure(withModel: ProductElement(title: "Products You May Like", delegate: self, scrollDelegate: nil, products: recommended))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.ReviewCell.CellIdentifier , for: indexPath) as! ReviewTableViewCell
            
            if loading == false {
                cell.review = reviews[0]
                cell.configureUI()
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
            } else {
                cell.startLoading()
            }

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
        
        self.delegate?.addToList(product!, cell: nil)
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {

        let quantity = sender.value
        stepperLabel.text = String(format: "%.0f", quantity)
        
        product!.quantity = Int(quantity)
        quantityStepper.value = quantity
        delegate?.updateQuantity(product!)
        
        if(quantity == 0){
            showAddButtonView()
            delegate?.removeFromList(product!)
            
            quantityStepper.value = 1
            stepperLabel.text = "1"
        }
        
    }
    
    func showAddButtonView(){
        print("Show Add Button")
        stepperStackView.isHidden = true
        addButton.isHidden = false
    }
    
    func showQuantityView(){
        print("Show Quantity View")
        stepperStackView.isHidden = false
        addButton.isHidden = true
    }
    
    
    func addToList(_ productItem: ProductModel, cell: GroceryTableViewCell?){
        
        if cell != nil {
            productItem.parent_category_id = product!.parent_category_id
            productItem.parent_category_name = product!.parent_category_name
            delegate?.addToList(productItem, cell: cell)
        } else {
            let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "listsViewController"))! as! ListsViewController
            destinationVC.delegate = self
            
            self.present(destinationVC, animated: true)
            self.add_to_list_product_id = product!.id
        }
        
        print("Adding To List")
    }
    
    
    func listSelected(list_id: Int) {
        self.selected_list_id = list_id
        listHandler.create(list_id: list_id, list_data: ["product_id": String(add_to_list_product_id!)])
        showQuantityView()
    }
    
    func updateQuantity(_ product: ProductModel) {

        if selected_list_id != nil {
         
            let data:[String: String] = [
                "product_id": String(product.id),
                "quantity": String(product.quantity),
                "ticked_off": "false"
            ]
            
            listHandler.update(list_id:selected_list_id!, list_data: data)
            
        }
       
    }
    
    func showGroceryItem(_ product_id: Int) {
        
    }
    
    func removeFromList(_ product: ProductModel) {
        
    }
    
}
