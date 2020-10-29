//
//  SearchResultsViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import RealmSwift

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SearchResultsDelegate, QuanityChangedDelegate, ListSelectedDelegate, GroceryDelegate, RefineSelectedDelegate {
    
    let realm = try! Realm()
    
    @IBOutlet weak var resultsTableView: UITableView!
    
    @IBOutlet var refineView: UIView!
    
    var products:[ProductModel] = []
    
    var delegate:GroceryDelegate?
    
    var searchHandler: SearchHandler = SearchHandler()
    
    var searchDetails: SearchModel?
    
    var userHandler = UserHandler()
    
    @IBOutlet weak var totalProductsLabel: UILabel!
    
    var listHandler = ListItemsHandler()
    
    var selected_product: ProductModel?
    var selected_row: GroceryTableViewCell?
    
    var selectedListId: Int?
    
    var selectedSort: RefineSortModel?
    var selectedCategory: RefineModel?
    var selectedBrand: RefineModel?
    var selectedDietary: [RefineModel] = []
    
    var currentPage: Int = 1
    var loading: Bool = true
    
    var refreshControl = UIRefreshControl()
    
    var filters: [RefineOptionModel] = []
    var paginate: PaginateResultsModel?
    
    var listRequired: Bool = true
    
    var listManager: ListManager = ListManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableView.register(UINib(nibName: K.Cells.GroceryCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.GroceryCell.CellIdentifier)
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        resultsTableView.addSubview(refreshControl)
        
        let refineGesture = UITapGestureRecognizer(target: self, action: #selector(refinePressed))
        refineView.addGestureRecognizer(refineGesture)

        self.title = searchDetails!.name
        
        searchHandler.resultsDelegate = self
        
        search()
        searchHistory()
        
        self.delegate = self
        
        if(selectedListId != nil){
            self.listRequired = false
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
        
    func contentLoaded(stores: [StoreModel], products: [ProductModel], paginate: PaginateResultsModel?) {
        
        if currentPage == 1 {
            self.products = []
            self.filters = []
        }
        
        self.products.append(contentsOf: products)
        self.paginate = paginate

        generateFilters()
        
        for product in products {
            addToHistory(product)
        }
        
        loading = false
        totalProductsLabel.text = "\(self.products.count) Products"
        resultsTableView.reloadData()
        refreshControl.endRefreshing()

    }
    
    func errorHandler(_ message: String) {
        loading = false
        self.resultsTableView.reloadData()
        showError(message)
    }
    
    func logOutUser(){
        userHandler.userSession.viewController = self
        userHandler.requestLogout()
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Search Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}

//MARK: - Refine Results
extension SearchResultsViewController {
    
    func generateFilters(){
        
        var filterCategories: RefineOptionModel = RefineOptionModel(header: "Categories", values: [], type: .category)
        var filterBrands: RefineOptionModel = RefineOptionModel(header: "Brands", values: [], type: .brand)
        
        var uniqueBrands: [String: Int] = [:]
        var uniqueCategories: [String: Int] = [:]
                    
        for product in products {
            
            if product.brand != nil {
                if uniqueBrands[product.brand!] == nil {
                    uniqueBrands[product.brand!] = 1
                } else {
                    uniqueBrands[product.brand!] = uniqueBrands[product.brand!]! + 1
                }
            }

            if product.childCategoryName != nil {
                if uniqueCategories[product.childCategoryName!] == nil {
                    uniqueCategories[product.childCategoryName!] = 1
                } else {
                    uniqueCategories[product.childCategoryName!] = uniqueCategories[product.childCategoryName!]! + 1
                }
            }
            
        }
        
        for category in uniqueCategories {
            filterCategories.values.append(RefineModel(name: category.key, selected: false, quantity: category.value))
        }
        
        for brand in uniqueBrands {
            filterBrands.values.append(RefineModel(name: brand.key, selected: false, quantity: brand.value))
        }

        self.filters = [filterBrands, filterCategories]
    }
    
    func applyOptions(sort: RefineSortModel?, category: RefineModel?,brand: RefineModel?, dietary: [RefineModel]){
        selectedSort = sort
        selectedCategory = category
        selectedDietary = dietary
        selectedBrand = brand
        currentPage = 1
        search()
    }
    
    func search(refresh: Bool = true){
        
        var data = ["type": getSearchType(), "detail": searchDetails!.name]
        
        if selectedSort != nil {
            let sortBy = selectedSort!.sort
            let orderBy: String
            
            if selectedSort!.order == .asc {
                orderBy = "asc"
            } else {
                orderBy = "desc"
            }
            
            data["sort"] = sortBy
            data["order"] = orderBy
        }
        
        if selectedCategory != nil {
            data["child_category"] = selectedCategory!.name
        }
        
        if selectedBrand != nil {
            data["brand"] = selectedBrand!.name
        }
        
        if selectedDietary.count > 0 {
            data["dietary"] = selectedDietary.compactMap({ $0.name }).joined(separator: ",")
        }
        
        
        if refresh {
            
            self.products = []
            self.filters = []
            
            loading = true
            
            if products.count > 0 {
                resultsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
            
            resultsTableView.reloadData()
        }
        
        searchHandler.requestResults(searchData: data, page: currentPage)
    }
    
    func getSearchType() -> String {
        var typeString: String
        
        if searchDetails!.type == .childCategory {
            typeString = "child_categories"
        } else if searchDetails!.type == .parentCategory {
            typeString = "parent_categories"
        } else {
            typeString = "products"
        }
        
        return typeString
    }
    
    func clearAllOptions() {
        selectedSort = nil
        selectedCategory = nil
        selectedDietary = []
        selectedBrand = nil
        
        loading = true
        resultsTableView.reloadData()
        
        search()
    }
    
    
    @objc func refinePressed(){
        if loading == false {
            self.performSegue(withIdentifier: "resultsOption", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultsOption" {
            let destinationVC = segue.destination as! RefineViewController
            destinationVC.delegate = self
            destinationVC.refineHistory = RefineHistoryModel(sort: selectedSort, category: selectedCategory,dietary: selectedDietary, brand: selectedBrand)
            destinationVC.filters = self.filters
        }
    }
    
}

//MARK: - List Handling
extension SearchResultsViewController {
    
    func updateProductQuantity(index: Int, quantity: Int) {
        products[index].quantity = quantity
    }

    func addToList(_ product: ProductModel, cell: GroceryTableViewCell?){
        
        selected_product = product
        selected_row = cell
        
        if listRequired {
            let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "listsViewController"))! as! ListsViewController
            destinationVC.delegate = self
            present(destinationVC, animated: true)
        } else {
            let item = listManager.addProductToList(listId: selectedListId!, product: selected_product!)
            selected_row!.product?.quantity = item.quantity
            selected_row!.show_quantity_view()
            listHandler.create(list_id: selectedListId!, list_data: ["product_id": String(selected_product!.id)])
        }

    }
    
    func listSelected(list_id: Int) {
        self.selectedListId = list_id
        listHandler.create(list_id: list_id, list_data: ["product_id": String(selected_product!.id)])
        
        let item = listManager.addProductToList(listId: list_id, product: selected_product!)
        selected_row!.product?.quantity = item.quantity
        selected_row!.show_quantity_view()
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    func showGroceryItem(_ product_id: Int) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        destinationVC.product_id = product_id
        
        if !listRequired {
            destinationVC.selectedListId = selectedListId
        }
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func updateQuantity(_ product: ProductModel) {
        let data:[String: String] = [
            "product_id": String(product.id),
            "quantity": String(product.quantity),
            "ticked_off": "false"
        ]
        
        listManager.updateProduct(listId: selectedListId!, product: product)
            
        listHandler.update(listId:selectedListId!, listData: data)
    }

}

//MARK: - TableView
extension SearchResultsViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 5 : products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTableView.dequeueReusableCell(withIdentifier:K.Cells.GroceryCell.CellIdentifier , for: indexPath) as! GroceryTableViewCell
        
        if paginate != nil && paginate!.more_available && indexPath.row + 1 == products.count && currentPage <= paginate!.to{
            // Load More Items At End
            currentPage = currentPage + 1
            search(refresh: false)
        }
        
        if loading == false {
            
            cell.product = products[indexPath.row]
            
            if selectedListId != nil {
                let listItem = realm.objects(ListItemHistory.self).filter("list_id = \(selectedListId!) AND product_id=\( products[indexPath.row].id )").first
                
                if listItem != nil {
                    cell.product!.quantity = listItem!.quantity
                }
            }

            cell.delegate = self.delegate
            cell.quantity_delegate = self
            
            cell.index = indexPath.row
            cell.configureUI()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        } else {
            cell.startLoading()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_row = tableView.cellForRow(at: indexPath) as? GroceryTableViewCell
        showGroceryItem(products[indexPath.row].id)
    }

    @objc func refresh(){
        search()
    }

}

//MARK: - Search History
extension SearchResultsViewController {
    
    func searchHistory(){

        self.products = []
        self.filters = []
        
        if searchDetails!.type == .childCategory {
            let category = realm.objects(ChildCategoryHistory.self).filter("id = %@", searchDetails!.id).first
            
            if category != nil {
                category!.products.forEach({ products.append($0.getProductModel()) })
            }
           
        } else if searchDetails!.type == .parentCategory {
            let results = realm.objects(ProductHistory.self).filter("parentCategoryId = %@", searchDetails!.id).sorted(byKeyPath: "avgRating", ascending: false)
            products = results.map{ $0.getProductModel() }
        } else {
            let results = realm.objects(ProductHistory.self).filter("name CONTAINS[c] %@", searchDetails!.name).sorted(byKeyPath: "avgRating", ascending: false)
            products = results.map{ $0.getProductModel() }
        }
     
        products.sort { (productA, productB) -> Bool in
            return (productA.avgRating / Double(productA.totalReviewsCount)) < (productB.avgRating / Double(productB.totalReviewsCount))
        }
        
        if products.count > 0 {
            loading = false
            totalProductsLabel.text = "\(products.count) Products"
            resultsTableView.reloadData()
            refreshControl.endRefreshing()
        }
        
    }
    
    func addToHistory(_ product: ProductModel){
    
        var productItem = realm.objects(ProductHistory.self).filter("id = \(product.product_id)").first
        
        try! realm.write() {
            if productItem == nil {
                
                if searchDetails!.type != .childCategory {
                    realm.add(product.getRealmObject())
                } else {
                    let category = realm.objects(ChildCategoryHistory.self).filter("id = %@", searchDetails!.id).first
                    category!.products.append(product.getRealmObject())
                    print("Adding Results To Child Category")
                }
                    
            } else {
                // Add to product history
                productItem = product.getRealmObject()
            }
            
        }
        
    }
}
