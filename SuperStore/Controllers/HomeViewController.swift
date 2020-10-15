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

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,ShowListDelegate, ProductDelegate, ScrollCollectionDelegate, OfferSelectedDelegate, ListSelectedDelegate, HomeDelegate, StoreSelectedDelegate {

    @IBOutlet weak var listTableView: UITableView!
    
    var customElements: [CustomElementModel] = []
    
    var refreshControl = UIRefreshControl()
    
    var scrollPositions: [String: CGFloat] = [:]
    
    var homeHandler = HomeHandler()
    
    var content: HomeModel?
    
    var loading: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeHandler.delegate = self
        homeHandler.request()
        
        createHomeSections()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        listTableView.addSubview(refreshControl)
        
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
    
    func contentLoaded(content: HomeModel) {
        self.content = content
        self.loading = false
        
        let listElement = customElements[0] as! ListsProgressElement
        listElement.lists = content.lists
        
        let storeElement = customElements[1] as! StoresMapElement
        storeElement.stores = content.stores

        let groceryProductElement = customElements[2] as! ProductElement
        groceryProductElement.products = content.groceries

        addSectionProducts(content.groceries, 2)
        addSectionProducts(content.monitoring, 3)
        
        let offerElement = customElements[4] as! OffersElement
        offerElement.promotions = content.promotions
        
        let featuredElement = customElements[5] as! FeaturedProductElement
        featuredElement.products = content.featured
        
        for category in content.categories {
            let name = category.key
            let products = category.value
            
            let element = ProductElement(title: name,delegate: self, scrollDelegate: self, products: products)
            customElements.append(element)
        }
        
        listTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func addSectionProducts( _ products: [ProductModel], _ elementIndex:Int){
        let productElement = customElements[elementIndex] as! ProductElement
        productElement.products = products
    }
    
    func errorHandler(_ message: String) {
        
    }
    
    @objc func refresh(){
        self.loading = true
        createHomeSections()
        listTableView.reloadData()
        homeHandler.request()
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

        cellModel.loading = self.loading
        customCell.configure(withModel: cellModel)

        let cell = customCell as! UITableViewCell

        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }

}
extension  HomeViewController {
    
    func createHomeSections(){
        customElements = [
            
//            ListPriceUpdateElement(title: "Grocery List Price Changes",delegate: self),
            
            ListsProgressElement(title: "List Progress", delegate: self, lists: []),

            StoresMapElement(title: "Stores", stores: [], delegate: self),

            ProductElement(title: "Grocery Items",delegate: self, scrollDelegate: self, products: []),

            ProductElement(title: "Monitoring",delegate: self, scrollDelegate: self, products: []),

            OffersElement(title: "Offers", delegate: self, promotions: []),

            FeaturedProductElement(title: "Featured",delegate: self, products: []),

//            ProductElement(title: "Fruits",delegate: self, scrollDelegate: self, products: []),
//
//            ProductElement(title: "Vegetables",delegate: self, scrollDelegate: self, products: [])
            
        ]
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
    
    func listSelected(list_id: Int) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "listViewController"))! as! ListViewController
        destinationVC.list_id = list_id
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
    
    func storePressed(store_id: Int) {
        print("Store Selected")
    }
    
    func storeSelected(store_id: Int) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "storeViewController"))! as! StoreViewController
        destinationVC.store_id = store_id
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

// Possible custom tablecell types with identifiers
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
    var loading: Bool { get set }
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
