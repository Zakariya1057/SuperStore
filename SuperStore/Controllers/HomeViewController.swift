//
//  HomeViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
//import AlamofireImage
//import Alamofire
import Kingfisher

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
            
            ListPriceUpdateElement(title: "List Element",delegate: self, height: 210),

            StoresMapElement(title: "Store Locations", height: 250),

            ProductElement(title: "Offers",delegate: self, products: [
            ListProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10, quantity: 1, ticked: false),
            ListProductModel(id: 2, name: "Shazans Halal Peri Peri Chicken Thighs", image: "http://192.168.1.187/api/image/products/1000186031097_small.jpg", description: "Bread", price: 2.40, location: "Aisle B", avg_rating: 4.6, total_reviews_count: 200, quantity: 1, ticked: false),
            ListProductModel(id: 3, name: "McVitie's The Original Digestive Biscuits Twin Pack", image: "http://192.168.1.187/api/image/products/1000186031105_small.jpg", description: "Bread", price: 3.40, location: "Aisle C", avg_rating: 2.2, total_reviews_count: 132, quantity: 1, ticked: false),
            ListProductModel(id: 4, name: "Ben & Jerry's Non-Dairy & Vegan Chocolate Fudge Brownie Ice Cream", image: "http://192.168.1.187/api/image/products/910001256210_small.jpg", description: "Bread", price: 4.40, location: "Aisle D", avg_rating: 1.5, total_reviews_count: 1, quantity: 12, ticked: false),
            ListProductModel(id: 5, name: "ASDA Extra Special Chilli Pork Sausage Ladder", image: "http://192.168.1.187/api/image/products/910001256396_small.jpg", description: "Bread", price: 5.40, location: "Aisle E", avg_rating: 4.1, total_reviews_count: 122, quantity: 1, ticked: false),
            ListProductModel(id: 6, name: "Preema Disposable Face Coverings 5 x 4 Packs (20 Coverings)", image: "http://192.168.1.187/api/image/products/910001256410_small.jpg", description: "Bread", price: 6.40, location: "Aisle F", avg_rating: 4.4, total_reviews_count: 11, quantity: 1, ticked: false),
            ListProductModel(id: 7, name: "Nivea Sun Kids Suncream Spray SPF 50+ Coloured", image: "http://192.168.1.187/api/image/products/910001257216_small.jpg", description: "Bread", price: 7.40, location: "Aisle G", avg_rating: 3.4, total_reviews_count: 123, quantity: 3, ticked: false)
            ], height: 280),


//            ProductElement(title: "Offers",delegate: self, products: ["Product 1","Product 2","Product 3","Product 4","Product 1","Product 2","Product 3","Product 4"]),
            
//            ProductElement(title: "Favoured Price Changes",delegate: self, products: ["Item 2"]),
//
//            // Most popular food categories. Best in each group.
//            ProductElement(title: "Best Fruits",delegate: self, products: ["Item 3"]),
//            ProductElement(title: "Best Vegetables",delegate: self, products: ["Item 4"]),
//            ProductElement(title: "Best Halal Chicken",delegate: self, products: ["Product 4","Product 3","Product 3","Product 3","Product 3","Product 2","Product 1","Product 0"]),
//            ProductElement(title: "Best Chicken",delegate: self, products: ["Item 6"]),
            
        ]

        
        listTableView.register(UINib(nibName: K.Cells.ListPriceUpdateCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ListPriceUpdateCell.CellIdentifier)
        
        listTableView.register(UINib(nibName: K.Cells.ProductCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ProductCell.CellIdentifier)
        
        listTableView.register(UINib(nibName: K.Cells.StoreMapCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.StoreMapCell.CellIdentifier)
        
//        listTableView.rowHeight = 260
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel = customElements[indexPath.row]
        return CGFloat(cellModel.height)
    }
    
}


extension HomeViewController {
    func showListPage(){
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "listsViewController"))! as! ListsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showProduct(product_id: Int) {
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        vc.product_id = product_id
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
    var height: Float { get }
}

protocol CustomElementCell: class {
    func configure(withModel: CustomElementModel)
}




extension UIImageView {
    func downloaded(from urlString: String, contentMode mode: UIView.ContentMode = .scaleAspectFit)  {
        
        if let url  = URL(string: urlString) {
            self.kf.indicatorType = .activity
            self.kf.setImage(with: url)
        }

    }
    
}

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 15 }
    var boldFontSize: CGFloat { return 17 }
    
    var boldFont:UIFont { return UIFont(name: "OpenSans-SemiBold", size: boldFontSize) ?? UIFont.boldSystemFont(ofSize: boldFontSize) }
    var normalFont:UIFont { return UIFont(name: "OpenSans-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}

    func bold(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func blackHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func underlined(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
