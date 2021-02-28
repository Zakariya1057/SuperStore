import UIKit
import Cosmos

//protocol GroceryDelegate {
//    func showGroceryItem(_ productID: Int)
//    func addToList(_ product: ProductModel, cell: GroceryTableViewCell?)
//    func updateQuantity(_ product: ProductModel)
//}
//
//protocol QuanityChangedDelegate {
//    func updateProductQuantity(index: Int, quantity: Int)
//}

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var storeNameLabel: UILabel!
    
//    var delegate:GroceryDelegate?
    
//    var grandParentCategory: GrandParentCategoryModel?
    
    @IBOutlet weak var stepper_stack_view: UIStackView!
    @IBOutlet weak var stepper_label: UILabel!
    var product: ProductModel?
    
    var showAddButton: Bool = true
    var showStoreName: Bool = false
    var hideAll: Bool = false
    
//    var quantity_delegate: QuanityChangedDelegate?
    
    var index: Int?
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewView: CosmosView!
    @IBOutlet weak var left_info_view: UIView!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    var loadingViews: [UIView] {
        return [productImage,productNameLabel,reviewView,bottomStackView]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
//    var listManager: ListManager = ListManager()
    
    func configureUI(){
        let currentProduct = product!
        
        stopLoading()
        productNameLabel.text = currentProduct.name
        if currentProduct.weight != nil {
            productNameLabel.text! += " (\(currentProduct.weight!))"
        }
        
        showPrice()
        
        productImage.downloaded(from: currentProduct.smallImage)
        
        let rating = currentProduct.avgRating
        let num = currentProduct.totalReviewsCount
        
        reviewView.rating = rating
        reviewView.text = "(\(num))"
        
        if hideAll {
            return hide_all()
        }
        
//        if(product!.quantity > 0){
//            show_quantity_view()
//
//            stepper_label.text = String(product!.quantity)
//            quantityStepper.value = Double(product!.quantity)
//
//        } else {
//            if(showAddButton){
//                print("Show Add Button")
//                stepper_label.text = "1"
//                quantityStepper.value = 1
//
//                show_add_button_view()
//            }
//
//            if (showStoreName){
//                show_store_name_view()
//            }
//        }
        
    }
    
    func showPrice(){
//        if product!.quantity > 0 {
//            priceLabel.text = "£" + String(format: "%.2f", listManager.calculateProductPrice(product!))
//        } else {
//            priceLabel.text = "£" + String(format: "%.2f", product!.price)
//        }
    }
    
    func startLoading(){
        for item in loadingViews {
            item.isSkeletonable = true
            item.showAnimatedGradientSkeleton()
        }
    }
    
    func stopLoading(){
        for item in loadingViews {
            item.hideSkeleton()
        }
    }
}

extension ProductCell {
//    @IBAction func stepper_pressed(_ sender: UIStepper) {
//        let quantity = sender.value
//        stepper_label.text = String(format: "%.0f", quantity)
//
//        product!.quantity = Int(quantity)
//
//        quantity_delegate?.updateProductQuantity(index: index!, quantity: product!.quantity)
//
//        if delegate != nil {
//            delegate?.updateQuantity(product!)
//
//            if(quantity == 0){
//                show_add_button_view()
//
//                stepper_label.text = "1"
//                quantityStepper.value = 1
//
//                product!.quantity = 1
//            }
//        }
//
//        showPrice()
//
//    }
//
//
//    @IBAction func groceryAddClicked(_ sender: Any) {
//        self.delegate?.addToList(self.product!,cell: self)
//        quantity_delegate?.updateProductQuantity(index: index!, quantity: 1)
//    }
}

extension ProductCell {
    func show_quantity_view(){
        stepper_stack_view.isHidden = false
        left_info_view.isHidden = true
    }
    
    func show_add_button_view(){
        left_info_view.isHidden = false
        stepper_stack_view.isHidden = true
        storeNameLabel.isHidden = true
        addButton.isHidden = false
    }
    
    func show_store_name_view(){
        left_info_view.isHidden = false
        stepper_stack_view.isHidden = true
        storeNameLabel.isHidden = false
        addButton.isHidden = true
    }
    
    func hide_all(){
        left_info_view.isHidden = true
        stepper_stack_view.isHidden = true
        storeNameLabel.isHidden = true
        addButton.isHidden = true
    }
}
