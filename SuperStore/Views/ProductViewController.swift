//
//  ProductViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, ProductDelegate {
    
    @IBOutlet weak var ingredientsView: UIView!
    
//    @IBOutlet weak var similarCollection: UICollectionView!
    @IBOutlet weak var similarTableView: UITableView!
    
    var similarProducts = ["Item 1","Item 2","Item 3","Item 4","Item 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        similarTableView.register(UINib(nibName: K.Cells.ProductCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ProductCell.CellIdentifier)
        
//        similarCollection.register(UINib(nibName: K.Cells.ProductCollectionCell.CellNibName, bundle: nil), forCellWithReuseIdentifier:  K.Cells.ProductCollectionCell.CellIdentifier)
//
//        similarCollection.delegate = self
//        similarCollection.dataSource = self

        similarTableView.delegate = self
        similarTableView.dataSource = self
        
        similarTableView.rowHeight = 280;
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showIngredients))
        ingredientsView.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func showIngredients(){
        self.performSegue(withIdentifier: "showIngredients", sender: self)
    }
    
    
}

extension ProductViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.ProductCell.CellIdentifier, for: indexPath) as! ProductTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.titleLabel.text = "Products You May Like"
        cell.delegate = self
        return cell
    }
    
    func showProduct(productId: Int) {
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
//extension ProductViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return similarProducts.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = similarCollection.dequeueReusableCell(withReuseIdentifier: K.Cells.ProductCollectionCell.CellIdentifier, for: indexPath as IndexPath) as? ProductCollectionViewCell {
//            
//                
//            return cell
//        }
//        return UICollectionViewCell()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        // Product Selected, Navigate
//    }
//    
//    func updateView(){
//    }
//
//    
//}


