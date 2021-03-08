import UIKit
import Cosmos

class ProductCell: UITableViewCell {
    var product: ProductModel!
    
    var addToList: Bool = false
    
    var addToListPressed:((ProductModel) -> Void)? = nil
    var updateQuantityPressed: ((ProductModel) -> Void)? = nil
    
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ratingView: CosmosView!
    
    @IBOutlet var addView: UIView!
    
    @IBOutlet var quantityStepper: UIStepper!
    @IBOutlet var quanityLabel: UILabel!
    @IBOutlet var quantityView: UIView!
    
    @IBOutlet var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureUI(){
        nameLabel.text = product.name
        productImageView.downloaded(from: product.smallImage)
        ratingView.rating = product.avgRating
        ratingView.text = "(\(product.totalReviewsCount))"
        priceLabel.text = "£" + String(format: "%.2f", product.price)
        
        displayButtons()
    }
    
    func displayButtons(){
        if addToList {
            if product.quantity > 0 {
                updateQuanity(quantity: product.quantity)
                quantityView.isHidden = false
                addView.isHidden = true
            } else {
                quantityView.isHidden = true
                addView.isHidden = false
            }
        } else {
            addView.isHidden = true
            quantityView.isHidden = true
        }
    }
}

extension ProductCell {
    
    @IBAction func stepperPressed(_ stepper: UIStepper) {
        let quantity: Int = Int(stepper.value)
        
        if quantity == 0 {
            addView.isHidden = false
            quantityView.isHidden = true
        }
        
        updateQuanity(quantity: quantity)
        
        if let updateQuantityPressed = updateQuantityPressed {
            updateQuantityPressed(product)
        }
    }
    
    @IBAction func addButtonPressed(_ button: UIButton) {
        updateQuanity(quantity: 1)
        if let addToListPressed = addToListPressed {
            addToListPressed(product)
        }
    }
    
    func updateQuanity(quantity: Int){
        product.quantity = quantity
        quantityStepper.value = Double(quantity)
        quanityLabel.text = "\(quantity)"
    }
}
