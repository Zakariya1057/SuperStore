//
//  ProductTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ProductElement: CustomElementModel {
    var title: String
    var type: CustomElementType { return .products }
    var delegate: ProductDelegate
    var products: [ProductModel]
    var height: Float
        
    init(title: String,delegate: ProductDelegate,products: [ProductModel],height: Float) {
        self.title = title
        self.delegate = delegate
        self.products = products
        self.height = height
    }
}

protocol ProductDelegate {
    func showProduct(product_id:Int)
}

class ProductTableViewCell: UITableViewCell,CustomElementCell {
    
    @IBOutlet weak var productCollection: UICollectionView!
    
    var model: ProductElement!
    var products: [ProductModel] = []
    
    var delegate:ProductDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? ProductElement else {
            print("Unable to cast model as ProductElement: \(elementModel)")
            return
        }
        
        self.model = model
        self.delegate = model.delegate
        
        self.products = model.products
        self.productCollection.reloadData()
        
        configureUI()
    }
    
    func configureUI() {
        titleLabel.text = self.model.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productCollection.register(UINib(nibName: K.Cells.ProductCollectionCell.CellNibName, bundle: nil), forCellWithReuseIdentifier:  K.Cells.ProductCollectionCell.CellIdentifier)
        
        productCollection.delegate = self
        productCollection.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension ProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCollection.dequeueReusableCell(withReuseIdentifier: K.Cells.ProductCollectionCell.CellIdentifier, for: indexPath) as! ProductCollectionViewCell
        cell.product = products[indexPath.row]
        cell.configureUI()
//        cell.productLabel.text = productsList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Product Selected, Navigate
        print("Product Selected")
        self.delegate?.showProduct(product_id: products[indexPath.row].id)
    }
    
    
}

