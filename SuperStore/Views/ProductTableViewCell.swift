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
    var products: [String]
        
    init(title: String,delegate: ProductDelegate,products: [String]) {
        self.title = title
        self.delegate = delegate
        self.products = products
    }
}

protocol ProductDelegate {
    func showProduct(productId:Int)
}

class ProductTableViewCell: UITableViewCell,CustomElementCell {
    
    var model: ProductElement!
    
    var productsList = ["Product 1","Product 2","Product 3","Product 4","Product 1","Product 2","Product 3","Product 4"]
    
    var delegate:ProductDelegate?
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? ProductElement else {
            print("Unable to cast model as ProductElement: \(elementModel)")
            return
        }
        
        self.model = model
        self.delegate = model.delegate
        
        self.productCollection.reloadData()
        
        configureUI()
    }
    
    func configureUI() {
        titleLabel.text = self.model.title
    }
    
    
    
    @IBOutlet weak var productCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productCollection.register(UINib(nibName: K.Cells.ProductCollectionCell.CellNibName, bundle: nil), forCellWithReuseIdentifier:  K.Cells.ProductCollectionCell.CellIdentifier)
        
        productCollection.delegate = self
        productCollection.dataSource = self
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension ProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCollection.dequeueReusableCell(withReuseIdentifier: K.Cells.ProductCollectionCell.CellIdentifier, for: indexPath) as! ProductCollectionViewCell
//        cell.productLabel.text = productsList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Product Selected, Navigate
        print("Product Selected")
        self.delegate?.showProduct(productId: 1)
    }
    
    
}

