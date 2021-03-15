//
//  ProductCollectionViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 12/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    var product: ProductModel?
    
    var loading: Bool = true {
        didSet {
            loading ? startLoading() : stopLoading()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var loadingViews: [UIView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI(){
        if let product = product {
            imageView.downloaded(from: product.smallImage)
            nameLabel.text = product.name
            
            priceLabel.text = product.getPrice()
        }
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
