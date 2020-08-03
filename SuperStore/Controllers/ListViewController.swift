//
//  Choose your custom row height     } ListViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 30/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

protocol PriceChangeDelegate {
    func productChanged(product: ListProductModel, index: Int)
}

protocol StoreSelectedDelegate {
    func storeChanged(name: String,backgroundColor: UIColor)
}

protocol NewProductDelegate {
    func productAdded(product: ProductModel)
}

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,PriceChangeDelegate {
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var products:[ListProductModel] = [
        
        ListProductModel(id: 1, name: "Kingsmill Medium 50/50 Bread", image: "", description: "Bread", price: 1.40, location: "Aisle A", quantity: 1, ticked: false),
        ListProductModel(id: 1, name: "Shazans Halal Peri Peri Chicken Thighs", image: "", description: "Bread", price: 2.40, location: "Aisle B", quantity: 1, ticked: false),
        ListProductModel(id: 1, name: "McVitie's The Original Digestive Biscuits Twin Pack", image: "", description: "Bread", price: 3.40, location: "Aisle C", quantity: 1, ticked: false),
        ListProductModel(id: 1, name: "Ben & Jerry's Non-Dairy & Vegan Chocolate Fudge Brownie Ice Cream", image: "", description: "Bread", price: 4.40, location: "Aisle D", quantity: 1, ticked: false),
        ListProductModel(id: 1, name: "ASDA Extra Special Chilli Pork Sausage Ladder", image: "", description: "Bread", price: 5.40, location: "Aisle E", quantity: 1, ticked: false),
        ListProductModel(id: 1, name: "Preema Disposable Face Coverings 5 x 4 Packs (20 Coverings)", image: "", description: "Bread", price: 6.40, location: "Aisle F", quantity: 1, ticked: false),
        ListProductModel(id: 3, name: "Nivea Sun Kids Suncream Spray SPF 50+ Coloured", image: "", description: "Bread", price: 7.40, location: "Aisle G", quantity: 1, ticked: false)
    ]
    
    var delegate:PriceChangeDelegate?
    
    @IBOutlet weak var editBarItem: UIBarButtonItem!
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var addCategoryButton: UIButton!
    
    @IBOutlet weak var storeButton: UIButton!
    
    var editingEnabled:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.register(UINib(nibName: K.Cells.ListItemCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ListItemCell.CellIdentifier)
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        showTotalPrice()
        addCategoryButton.layer.cornerRadius = 30
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "groceryGroupViewController"))! as! GroceryGroupViewController
//        destinationVC.listDelegate = self
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    //    @IBAction func editButtonPressed(_ sender: Any) {
    //        if editingEnabled {
    //            listTableView.isEditing = false
    //        } else {
    //            listTableView.isEditing = true
    //        }
    //
    //        editingEnabled = !editingEnabled
    //    }
//
//    func getProduct(_ index: Int) -> ListProductModel {
//        let list = Array(products.values).sorted { (productA, productB) -> Bool in
//            return productA.location! < productB.location!
//        }
//
//        print(list.map({ prod in
//            return prod.name
//        }))
//
//        return list[index]
//    }
    
    func showTotalPrice(){
        var price:Double = 0.00
        
        for product in products {
            price = price + ( Double(product.quantity) * product.price)
        }
        
        self.totalPriceLabel.text = "£" + String(format: "%.2f", price)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:K.Cells.ListItemCell.CellIdentifier , for: indexPath) as! ListItemTableViewCell
        cell.product = products[indexPath.row]
        cell.productIndex = indexPath.row
        cell.delegate = self
        cell.configureUI()
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //         self.delegate?.showGroceryItem()
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        let count = products[indexPath.row].value.name.count
        let product = products[indexPath.row]
        
        let count = product.name.count
        
        if count > 40 {
            return 120;
        } else {
            return 103;
        }
    }

    
    func productChanged(product: ListProductModel, index: Int) {
        self.products[index] = product
        showTotalPrice()
    }
    
    
}

extension ListViewController: StoreSelectedDelegate {
    
    @IBAction func storeButtonPressed(_ sender: Any) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "storeSelectViewController"))! as! StoreSelectViewController
        
        destinationVC.delegate = self
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func storeChanged(name: String, backgroundColor: UIColor) {
        storeButton.setTitle(name, for: .normal)
        storeButton.backgroundColor = backgroundColor
    }
}

extension ListViewController: NewProductDelegate{
    func productAdded(product: ProductModel) {
        
        let listProduct = ListProductModel(
            id: product.id, name: product.name, image: product.image ?? "",
            description: product.description,
            price: product.price, location: product.location,
            quantity: 1, ticked: false)
        
        var productExists: Bool = false
        
        for productItem in products {
            if productItem.id == product.id {
                productExists = true
                break
            }
        }
        
        if productExists == false {
            self.products.append(listProduct)
        }
        
        listTableView.reloadData()
        showTotalPrice()
    }
}
