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
    var delegate: ProductDelegate?
    var scrollDelegate: ScrollCollectionDelegate?
    var products: [ProductModel]
    var position: CGFloat?
    var loading: Bool = false
    
    init(title: String,delegate: ProductDelegate, scrollDelegate: ScrollCollectionDelegate?,products: [ProductModel]) {
        self.title = title
        self.delegate = delegate
        self.products = products
        self.scrollDelegate = scrollDelegate
    }
}

protocol ScrollCollectionDelegate {
    func didScroll(to position: CGFloat, title: String)
}

protocol ProductDelegate {
    func showProduct(productID:Int)
}

class ProductTableViewCell: UITableViewCell,CustomElementCell {
    
    @IBOutlet weak var productCollection: UICollectionView!
    
    var model: ProductElement!
    var products: [ProductModel] = []
    
    var delegate:ProductDelegate?
    var scrollDelegate: ScrollCollectionDelegate?
    
    var loading: Bool = true
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? ProductElement else {
            print("Unable to cast model as ProductElement: \(elementModel)")
            return
        }
        
        self.model = model
        self.delegate = model.delegate
        self.scrollDelegate = model.scrollDelegate
        self.loading = model.loading
        
        self.products = model.products
        self.productCollection.reloadData()
        
        if model.position != nil {
            productCollection.contentOffset.x = model.position!
        } else {
            productCollection.contentOffset.x = CGFloat(0)
        }

        configureUI()
    }
    
    func configureUI() {
//        titleLabel.text = self.model.title
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        productCollection.register(UINib(nibName: K.Collections.ProductCollectionCell.CellNibName, bundle: nil), forCellWithReuseIdentifier: K.Collections.ProductCollectionCell.CellIdentifier)
        
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

extension ProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loading ? 5 : products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCollection.dequeueReusableCell(withReuseIdentifier: K.Collections.ProductCollectionCell.CellIdentifier, for: indexPath) as! ProductCollectionViewCell
        
        cell.loading = loading
        
        if !loading {
            cell.product = products[indexPath.row]
        }
        
        cell.configureUI()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !loading {
            self.delegate?.showProduct(productID: products[indexPath.row].id)
        }
    }

}

extension ProductTableViewCell: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.didScroll(to: scrollView.contentOffset.x, title: model.title)
    }
}

