//
//  ProductTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ProductGroupElement: HomeElementGroupModel {
    var title: String
    var type: HomeElementType = .products
    var items: [HomeElementItemModel]
    var productPressed: ((Int) -> Void)? = nil
    var loading: Bool = true
    
    init(title: String, products: [ProductsElementModel], productPressed: @escaping (Int) -> Void) {
        self.title = title
        self.items = products
        self.productPressed = productPressed
        
        configureProduct()
    }
    
    func configureProduct(){
        let products = items as! [ProductsElementModel]
        
        for (index, product) in products.enumerated() {
            product.index = index
            product.productPressed = productPressed
            product.scrolled = scrolled
        }
    }
    
    func setLoading(loading: Bool){
        self.loading = loading
        
        for item in items {
            item.loading = loading
        }
    }
    
    func scrolled(index: Int, position: CGFloat){
        let product = items[index] as! ProductsElementModel
        product.scrollPosition = position
    }
}

class ProductsElementModel: HomeElementItemModel {
    var products: [ProductModel] = []
    
    var loading: Bool = true
    
    var index: Int = 0
    var title: String = ""
    
    var scrollPosition: CGFloat = 0
    var productPressed: ((Int) -> Void)? = nil
    
    var scrolled: ((Int, CGFloat) -> Void)? = nil
    var parentScrolled: ((String, CGFloat) -> Void)? = nil
    
    init(products: [ProductModel]) {
        self.products = products
    }
}

class GroceryProductGroupElement: ProductGroupElement { }
class MonitoringProductGroupElement: ProductGroupElement { }

class OnSaleProductGroupElement: ProductGroupElement { }

class CategoryProductGroupElement: ProductGroupElement { }

class ProductsCell: UITableViewCell, HomeElementCell {
    
    @IBOutlet weak var productCollection: UICollectionView!
    
    var model: ProductsElementModel!
    var products: [ProductModel] = []
    
    var parentScrolled: ((String, CGFloat) -> Void)? = nil
    var productPressed: ((Int) -> Void?)? = nil
    
    var scrolled: ((Int, CGFloat) -> Void)?
    
    var loading: Bool = true
    
    @IBOutlet weak var titleLabel: UILabel!

    func configure(model elementModel: HomeElementItemModel) {
        guard let model = elementModel as? ProductsElementModel else {
            print("Unable to cast model as ProductElement: \(elementModel)")
            return
        }
        
        self.loading = model.loading
        
        self.model = model
        self.productPressed = model.productPressed
        
        self.scrolled = model.scrolled
        self.parentScrolled = model.parentScrolled
        
        self.products = model.products
        self.productCollection.reloadData()
        
        productCollection.contentOffset.x = model.scrollPosition

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
        cell.product = loading ? nil : products[indexPath.row]
        cell.configureUI()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !loading {
            if let productPressed = productPressed {
                productPressed(products[indexPath.row].id)
            }
        }
    }

}

extension ProductsCell: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrolled = scrolled {
            scrolled(model.index, scrollView.contentOffset.x)
        }
        
        if let parentScrolled = parentScrolled {
            parentScrolled(model.title, scrollView.contentOffset.x)
        }
    }
}

