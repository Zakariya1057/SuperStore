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

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,ShowListDelegate, ProductDelegate, ScrollCollectionDelegate, OfferSelectedDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var customElements: [CustomElementModel] = []
    
    var refreshControl = UIRefreshControl()
    
    var scrollPositions: [String: CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        listTableView.addSubview(refreshControl)
        
        customElements = [
            
//            ListPriceUpdateElement(title: "Grocery List Price Changes",delegate: self),
            
            ListsProgressElement(title: "Progress", delegate: self),

            StoresMapElement(title: "Stores"),

            ProductElement(title: "Grocery Items Sale",delegate: self, scrollDelegate: self, products: [
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil)
             ]),
            
            ProductElement(title: "Monitored",delegate: self, scrollDelegate: self, products: [
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil)
             ]),
            
            OffersElement(title: "Offers", delegate: self),
            
            FeaturedProductElement(title: "Featured",delegate: self, products: [
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil)
             ]),
            
            ProductElement(title: "Fruits",delegate: self, scrollDelegate: self, products: [
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil)
             ]),
            
            ProductElement(title: "Vegetables",delegate: self, scrollDelegate: self, products: [
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil),
                ProductModel(id: 1, name: "New Kingsmill Medium 50/50 Bread", image: "http://192.168.1.187/api/image/products/1000169226198_small.jpg", description: "Bread", quantity: 0, weight: "", parent_category_id: nil, parent_category_name: nil, price: 1.40, location: "Aisle A", avg_rating: 3.5, total_reviews_count: 10,discount: nil)
             ])
            
        ]
        
//        listTableView.register(UINib(nibName: K.Cells.ListPriceUpdateCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ListPriceUpdateCell.CellIdentifier)

        listTableView.register(UINib(nibName: K.Cells.FeaturedProductCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.FeaturedProductCell.CellIdentifier)
        
        listTableView.register(UINib(nibName: K.Cells.OffersCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.OffersCell.CellIdentifier)
        
        listTableView.register(UINib(nibName: K.Cells.ListsProgressCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ListsProgressCell.CellIdentifier)
        
        listTableView.register(UINib(nibName: K.Cells.ProductCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.ProductCell.CellIdentifier)
        
        listTableView.register(UINib(nibName: K.Cells.StoreMapCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.StoreMapCell.CellIdentifier)
        
        let nib = UINib(nibName: K.Sections.HomeHeader.SectionNibName, bundle: nil)
        self.listTableView.register(nib, forHeaderFooterViewReuseIdentifier: K.Sections.HomeHeader.SectionIdentifier)
        
        listTableView.dataSource = self
        listTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @objc func refresh(){
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return customElements.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = customElements[section].title
        let header = listTableView.dequeueReusableHeaderFooterView(withIdentifier:  K.Sections.HomeHeader.SectionIdentifier) as! HomeSectionHeader
        header.headingLabel.text = title
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = customElements[indexPath.section]
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
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "listsViewController"))! as! ListsViewController
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func showProduct(product_id: Int) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        destinationVC.product_id = product_id
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func showPromotion(promotion_id: Int) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "promotionViewController"))! as! PromotionViewController
        destinationVC.promotion_id = promotion_id
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func didScroll(to position: CGFloat, title: String) {
    
        self.scrollPositions[title] = position
        for item in customElements {
            if item.title == title {
                item.position = position
            }
        }
        
    }
}

//Possible custom tablecell types with identifiers
enum CustomElementType: String {
    case products         = "ReusableProductTableViewCell"
    case storesMap        = "ReusableStoresMapTableViewCell"
    case listPriceUpdate  = "ReusableListPriceUpdateTableViewCell"
    case listsProgress    = "ReusableListsProgressTableViewCell"
    case offers           = "ReusableOffersTableViewCell"
    case featuredProducts = "ReusableFeaturedProductTableViewCell"
}

// Each custom element model must have a defined type which is a custom element type.
protocol CustomElementModel: class {
    var title: String { get }
    var type: CustomElementType { get }
    var position: CGFloat? { get set }
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
    var fontSize:CGFloat { return 16 }
    var boldFontSize: CGFloat { return 17 }
    
    var boldFont:UIFont { return UIFont(name: "System", size: boldFontSize) ?? UIFont.boldSystemFont(ofSize: boldFontSize) }
    var normalFont:UIFont { return UIFont(name: "System", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}

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
