//
//  ProductTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class FeaturedProductGroupElement: HomeElementGroupModel {
    var title: String
    var type: HomeElementType = .featuredProducts
    var items: [HomeElementItemModel]
    var productPressed: (Int) -> Void
    var showViewAllButton: Bool = false
    
    var loading: Bool = true
    
    init(title: String, products: [FeaturedProductsElementModel], productPressed: @escaping (Int) -> Void) {
        self.title = title
        self.items = products
        self.productPressed = productPressed
        
        configurePressed()
    }
    
    func configurePressed(){
        let products = items as! [FeaturedProductsElementModel]
        
        for product in products {
            product.productPressed = productPressed
        }
    }
    
    func setLoading(loading: Bool){
        self.loading = loading
        
        for item in items {
            item.loading = loading
        }
    }
}

class FeaturedProductsElementModel: HomeElementItemModel {
    var products: [ProductModel] = []
    var scrollPosition: Float = 0
    var productPressed: ((Int) -> Void)? = nil
    var loading: Bool = true
    
    init(products: [ProductModel]) {
        self.products = products
    }
}


class FeaturedProductCell: UITableViewCell, HomeElementCell {
    
    @IBOutlet weak var productCollection: UICollectionView!
    
    var model: FeaturedProductsElementModel!
    var products: [ProductModel] = []
    
    var productPressed: ((Int) -> Void?)? = nil
    var scrollCallBack: ((CGFloat, String) -> Void)? = nil
    
    var loading: Bool = false
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(model elementModel: HomeElementItemModel) {

        guard let model = elementModel as? FeaturedProductsElementModel else {
            print("Unable to cast model as FeaturedProductElement: \(elementModel)")
            return
        }
        
        self.model = model
        self.productPressed = model.productPressed
        self.loading = model.loading
        
        self.products = model.products
        self.productCollection.reloadData()
        self.productCollection.layoutIfNeeded()
    }

    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        productCollection.register(UINib(nibName: "FeaturedProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:  "FeaturedProductCollectionViewCell")
        
        productCollection.delegate = self
        productCollection.dataSource = self
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.productCollection.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension FeaturedProductCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loading ? 5 : products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCollection.dequeueReusableCell(withReuseIdentifier: "FeaturedProductCollectionViewCell", for: indexPath) as! FeaturedProductCollectionViewCell
        
        cell.loading = loading
        cell.product = loading ? nil : products[indexPath.row]
        cell.configureUI()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !loading {
            // Product Selected, Navigate
            if let productPressed = productPressed {
                productPressed(products[indexPath.row].id)
            }
        }
    }
}
