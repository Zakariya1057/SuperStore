//
//  ProductTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class FeaturedProductElement: CustomElementModel {
    var title: String
    var type: CustomElementType { return .featuredProducts }
    var delegate: ProductDelegate
    var products: [ProductModel]
    var position: CGFloat?
    var loading: Bool = false
    
    init(title: String,delegate: ProductDelegate,products: [ProductModel]) {
        self.title = title
        self.delegate = delegate
        self.products = products
    }
}

class FeaturedProductTableViewCell: UITableViewCell,CustomElementCell {
    
    @IBOutlet weak var productCollection: UICollectionView!
    
    var model: FeaturedProductElement!
    var products: [ProductModel] = []
    
    var delegate:ProductDelegate?
    
    var loading: Bool = true
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? FeaturedProductElement else {
            print("Unable to cast model as FeaturedProductElement: \(elementModel)")
            return
        }
        
        self.model = model
        self.delegate = model.delegate
        self.loading = model.loading
        
        self.products = model.products
        self.productCollection.reloadData()
        self.productCollection.layoutIfNeeded()

        configureUI()
    }
    
    
    func configureUI() {
//        titleLabel.text = self.model.title
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        productCollection.register(UINib(nibName: K.Collections.FeaturedProductsCollecionCell.CellNibName, bundle: nil), forCellWithReuseIdentifier:  K.Collections.FeaturedProductsCollecionCell.CellIdentifier)
        
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

extension FeaturedProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loading ? 5 : products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCollection.dequeueReusableCell(withReuseIdentifier: K.Collections.FeaturedProductsCollecionCell.CellIdentifier, for: indexPath) as! FeaturedProductCollectionViewCell
        
        cell.loading = loading
        
        if !loading {
            cell.product = products[indexPath.row]
        }
        
        cell.configureUI()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !loading {
            // Product Selected, Navigate
            print("Product Selected")
            self.delegate?.showProduct(product_id: products[indexPath.row].id)
        }
    }
}
