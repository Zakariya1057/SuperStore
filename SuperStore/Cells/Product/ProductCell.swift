import UIKit
import Cosmos

class ProductCell: UITableViewCell {
    var product: ProductModel!
    
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ratingView: CosmosView!
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
    }
}
