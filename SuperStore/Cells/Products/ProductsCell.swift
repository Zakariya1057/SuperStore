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
    
    var productPressedCallBack: (Int) -> Void
    var scrollCallBack: (CGFloat, String) -> Void
    
    var products: [ProductModel]
    var position: CGFloat?
    var loading: Bool = false
    
    init(title: String, productPressedCallBack: @escaping (Int) -> Void, scrollCallBack: @escaping (CGFloat, String) -> Void ,products: [ProductModel]) {
        self.title = title
        
        self.productPressedCallBack = productPressedCallBack
        self.scrollCallBack = scrollCallBack
        
        self.products = products
    }
}

class GroceryProductElement: ProductElement { }
class MonitoringProductElement: ProductElement { }

class ProductsCell: UITableViewCell,CustomElementCell {
    
    @IBOutlet weak var productCollection: UICollectionView!
    
    var model: ProductElement!
    var products: [ProductModel] = []
    
    var productPressedCallBack: ((Int) -> Void?)? = nil
    var scrollCallBack: ((CGFloat, String) -> Void)? = nil
    
    var loading: Bool = true
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? ProductElement else {
            print("Unable to cast model as ProductElement: \(elementModel)")
            return
        }
        
        self.model = model
        self.productPressedCallBack = model.productPressedCallBack
        self.scrollCallBack = model.scrollCallBack
        self.loading = model.loading
        
        self.products = model.products
        self.productCollection.reloadData()
        
        if model.position != nil {
            productCollection.contentOffset.x = model.position!
        } else {
            productCollection.contentOffset.x = CGFloat(0)
        }

    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        productCollection.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        
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

extension ProductsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loading ? 5 : products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCollection.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        
        cell.loading = loading
        
        if !loading {
            cell.product = products[indexPath.row]
        }
        
        cell.configureUI()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !loading {
            if let productPressedCallBack = productPressedCallBack {
                productPressedCallBack(products[indexPath.row].id)
            }
        }
    }

}

extension ProductsCell: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollCallBack = scrollCallBack {
            scrollCallBack(scrollView.contentOffset.x,model.title)
        }
    }
}

