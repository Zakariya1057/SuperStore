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

protocol ProductQuantityChangedDelegate {
    func quantityChanged(product_index: Int, quantity: Int)
}

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,PriceChangeDelegate, ProductQuantityChangedDelegate {

    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var sections: [String] = ["Fruits", "Vegetables", "Drinks"]
    
    var products:[ListProductModel] = [
        
        ListProductModel(id: 1, name: "Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", price: 1.40, location: "Aisle A", avg_rating: 1, total_reviews_count: 1, quantity: 5, ticked: false),
        ListProductModel(id: 1, name: "Shazans Halal Peri Peri Chicken Thighs", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", price: 2.40, location: "Aisle B", avg_rating: 1, total_reviews_count: 1,quantity: 2, ticked: false),
        ListProductModel(id: 1, name: "McVitie's The Original Digestive Biscuits Twin Pack", image: "", description: "Bread", price: 3.40, location: "Aisle C", avg_rating: 1, total_reviews_count: 1, quantity: 12, ticked: false),
        ListProductModel(id: 1, name: "Ben & Jerry's Non-Dairy & Vegan Chocolate Fudge Brownie Ice Cream", image: "", description: "Bread", price: 4.40, location: "Aisle D", avg_rating: 1, total_reviews_count: 4, quantity: 1, ticked: false),
        ListProductModel(id: 1, name: "ASDA Extra Special Chilli Pork Sausage Ladder", image: "", description: "Bread", price: 5.40, location: "Aisle E", avg_rating: 1, total_reviews_count: 1, quantity: 8, ticked: false),
        ListProductModel(id: 1, name: "Preema Disposable Face Coverings 5 x 4 Packs (20 Coverings)", image: "", description: "Bread", price: 6.40, location: "Aisle F", avg_rating: 1, total_reviews_count: 1, quantity: 9, ticked: false),
        ListProductModel(id: 3, name: "Nivea Sun Kids Suncream Spray SPF 50+ Coloured", image: "", description: "Bread", price: 7.40, location: "Aisle G", avg_rating: 1, total_reviews_count: 1, quantity: 1, ticked: false)
    ]
    
    var delegate:PriceChangeDelegate?
    
    @IBOutlet weak var editBarItem: UIBarButtonItem!
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var addCategoryButton: UIButton!
    
    @IBOutlet weak var storeButton: UIButton!
    
    var editingEnabled:Bool = false
    
    var selected_product_index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: K.Sections.ListHeader.SectionNibName, bundle: nil)
        self.listTableView.register(nib, forHeaderFooterViewReuseIdentifier: K.Sections.ListHeader.SectionIdentifier)
        
        self.listTableView.register(UINib(nibName: K.Cells.ListItemCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ListItemCell.CellIdentifier)
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        showTotalPrice()
        addCategoryButton.layer.cornerRadius = 25
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "grandParentCategoriesViewController"))! as! GrandParentCategoriesViewController
//        destinationVC.listDelegate = self
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func showTotalPrice(){
        var price:Double = 0.00
        
        for product in products {
            price = price + ( Double(product.quantity) * product.price)
        }
        
        self.totalPriceLabel.text = "£" + String(format: "%.2f", price)
    }
        
    func productChanged(product: ListProductModel, index: Int) {
        self.products[index] = product
        showTotalPrice()
    }
    
    
}

extension ListViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_product_index = indexPath.row
        self.performSegue(withIdentifier: "list_item_details", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = sections[section]
        let subtitle = "Aisle A"
        
        let header = listTableView.dequeueReusableHeaderFooterView(withIdentifier:  K.Sections.ListHeader.SectionIdentifier) as! ListSectionHeader
        
        header.headingLabel.text = title
        header.subHeadingLabel.text = subtitle
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let product = products[indexPath.row]
        
        let count = product.name.count
        
        if count > 40 {
            return 105;
        } else {
            return 85;
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "list_item_details" {
            let destinationVC = segue.destination as! ListItemViewController
            destinationVC.product_index = selected_product_index
            destinationVC.delegate = self
            destinationVC.product = products[selected_product_index]
        }
    }
    
    func productAdded(product: ProductModel) {
        
        let listProduct = ListProductModel(
            id: product.id, name: product.name, image: product.image,
            description: product.description ?? "",
            price: product.price, location: product.location,
            avg_rating: 1, total_reviews_count: 1,
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
    
    
    func quantityChanged(product_index: Int, quantity: Int) {
        products[product_index].quantity = quantity
        // Send Request To Update Quanity
        listTableView.reloadData()
        showTotalPrice()
    }
    
}
