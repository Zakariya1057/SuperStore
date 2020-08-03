//
//  HomeViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,ListDelegate, ProductDelegate {

    @IBOutlet weak var listTableView: UITableView!
    
    var customElements: [CustomElementModel] = []
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        listTableView.addSubview(refreshControl) // not required when using UITableViewController
        
        customElements = [
            
            ListPriceUpdateElement(title: "List Element",delegate: self),

            StoresMapElement(title: "Store Locations"),

            ProductElement(title: "Offers",delegate: self, products: ["Product 1","Product 2","Product 3","Product 4","Product 1","Product 2","Product 3","Product 4"]),
            
            ProductElement(title: "Favoured Price Changes",delegate: self, products: ["Item 2"]),
            
            // Most popular food categories. Best in each group.
            ProductElement(title: "Best Fruits",delegate: self, products: ["Item 3"]),
            ProductElement(title: "Best Vegetables",delegate: self, products: ["Item 4"]),
            ProductElement(title: "Best Halal Chicken",delegate: self, products: ["Product 4","Product 3","Product 3","Product 3","Product 3","Product 2","Product 1","Product 0"]),
            ProductElement(title: "Best Chicken",delegate: self, products: ["Item 6"]),
            
        ]

        
        listTableView.register(UINib(nibName: K.Cells.ListPriceUpdateCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ListPriceUpdateCell.CellIdentifier)
        
        listTableView.register(UINib(nibName: K.Cells.ProductCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ProductCell.CellIdentifier)
        
        listTableView.register(UINib(nibName: K.Cells.StoreMapCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.StoreMapCell.CellIdentifier)
        
        listTableView.rowHeight = 280
        
        listTableView.dataSource = self
        listTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @objc func refresh(){
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = customElements[indexPath.row]
        let cellIdentifier = cellModel.type.rawValue
        let customCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomElementCell

        customCell.configure(withModel: cellModel)

        let cell = customCell as! UITableViewCell

        cell.selectionStyle = UITableViewCell.SelectionStyle.none

        return cell
    }
    
}


extension HomeViewController {
    func showListPage(){
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "listsViewController"))! as! ListsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showProduct(productId: Int) {
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//Possible custom tablecell types with identifiers
enum CustomElementType: String {
    case products        = "ReusableProductTableViewCell"
    case storesMap       = "ReusableStoresMapTableViewCell"
    case listPriceUpdate = "ReusableListPriceUpdateTableViewCell"
}

// Each custom element model must have a defined type which is a custom element type.
protocol CustomElementModel: class {
    var type: CustomElementType { get }
}

protocol CustomElementCell: class {
    func configure(withModel: CustomElementModel)
}
