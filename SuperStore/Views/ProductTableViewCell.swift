//
//  ProductTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    var productsList = ["Product 1","Product 2","Product 3","Product 4"]
    
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

        // Configure the view for the selected state
    }
    
}

extension ProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = productCollection.dequeueReusableCell(withReuseIdentifier: K.Cells.ProductCollectionCell.CellIdentifier, for: indexPath as IndexPath) as? ProductCollectionViewCell {
            
                
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Product Selected, Navigate
    }
    
    func updateView(){
    }

    
}

