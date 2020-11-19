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
    
    var selectedProduct: ProductModel?
    var selected_row: GroceryTableViewCell?
    
    @IBOutlet var rightBarButton: UIBarButtonItem!
    var selectedListID: Int?
    
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
    
    var offline: Bool {
        return RequestHandler.sharedInstance.offline
    }
    
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
        
        if(selectedListID != nil){
            self.listRequired = false
        } else {
            rightBarButton.title = "Select List"
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
        
        if offline {
            return searchHistory()
        }
        
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
        
        totalProductsLabel.text = ""
        
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
        
        selectedProduct = product
        selected_row = cell
        
        if selectedProduct == nil {
            selectList()
        } else {
            let item = listManager.addProductToList(listID: selectedListID!, product: selectedProduct!)
            selected_row!.product?.quantity = item.quantity
            selected_row!.show_quantity_view()
            listHandler.create(listID: selectedListID!, listData: ["product_id": String(selectedProduct!.id)])
        }

    }
    
    func listSelected(listID: Int) {
        self.selectedListID = listID
        
        if selectedProduct != nil {
            listHandler.create(listID: listID, listData: ["product_id": String(selectedProduct!.id)])
            
            let item = listManager.addProductToList(listID: listID, product: selectedProduct!)
            selected_row!.product?.quantity = item.quantity
            selected_row!.show_quantity_view()
        }
        
        rightBarButton.title = "Change List"
        resultsTableView.reloadData()

    }
    
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        if listRequired {
            selectList()
        } else {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }

    }
    
    func selectList(){
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "listsViewController"))! as! ListsViewController
        destinationVC.delegate = self
        present(destinationVC, animated: true)
    }
    
    func showGroceryItem(_ productID: Int) {
        let destinationVC = (self.storyboard?.instantiateViewController(withIdentifier: "productViewController"))! as! ProductViewController
        destinationVC.productID = productID
        
        if !listRequired {
            destinationVC.selectedListID = selectedListID
        }
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func updateQuantity(_ product: ProductModel) {
        let data:[String: String] = [
            "product_id": String(product.id),
            "quantity": String(product.quantity),
            "ticked_off": "false"
        ]
        
        listManager.updateProduct(listID: selectedListID!, product: product)
            
        listHandler.update(listID:selectedListID!, listData: data)
    }

}

//MARK: - TableView
extension SearchResultsViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 5 : products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTableView.dequeueReusableCell(withIdentifier:K.Cells.GroceryCell.CellIdentifier , for: indexPath) as! GroceryTableViewCell
        
        if !offline && paginate != nil && paginate!.moreAvailable && indexPath.row + 1 == products.count && currentPage <= paginate!.to{
            // Load More Items At End
            currentPage = currentPage + 1
            search(refresh: false)
        }
        
        if loading == false {
            
            cell.product = products[indexPath.row]
            
            cell.product!.quantity = 0
            
            if selectedListID != nil {
                let listItem = realm.objects(ListItemHistory.self).filter("listID = \(selectedListID!) AND productID=\( products[indexPath.row].id )").first
                
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
        
        var sortBy: String = "avgRating"
        var ascending: Bool = false
        var filterBy: [String] = []
        
        if searchDetails!.type == .childCategory {
            filterBy.append("childCategoryName = \"\(searchDetails!.name)\"")
        } else if searchDetails!.type == .parentCategory {
            filterBy.append("parentCategoryId = \(searchDetails!.id)")
        } else {
            filterBy.append("name CONTAINS[c] \"\(searchDetails!.name)\"")
        }
        
        if selectedSort != nil {
            
            if selectedSort!.order == .asc {
                ascending = true
            }
            
            if selectedSort!.sort == "price" {
                sortBy = "price"
            }
            
        }
        
        if selectedBrand != nil {
            filterBy.append("brand = \"\(selectedBrand!.name)\" ")
        }

        if selectedDietary.count > 0 {
            for dietary in selectedDietary {
                filterBy.append("dietary_info contains \"\(dietary.name)\" ")
            }
        }
        
        if selectedCategory != nil {
            filterBy.append("childCategoryName = \"\(selectedCategory!.name)\" ")
        }
        
        let results = realm.objects(ProductHistory.self).filter(filterBy.joined(separator: " AND ")).sorted(byKeyPath: sortBy, ascending: ascending)
        
        products = results.map{ $0.getProductModel() }
        
        if selectedSort == nil || selectedSort!.sort == "rating" {
            products.sort { (productA, productB) -> Bool in
                return (productA.avgRating / Double(productA.totalReviewsCount)) < (productB.avgRating / Double(productB.totalReviewsCount))
            }
        }

        
        loading = false
        totalProductsLabel.text = "\(products.count) Products"
        resultsTableView.reloadData()
        refreshControl.endRefreshing()

        if products.count > 0 {
            resultsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
        generateFilters()

    }
    
    func addToHistory(_ product: ProductModel){
    
        var productItem = realm.objects(ProductHistory.self).filter("id = \(product.productID)").first
        
        try! realm.write() {
            if productItem == nil {
                
                if searchDetails!.type != .childCategory {
                    realm.add(product.getRealmObject())
                } else {
                    let category = realm.objects(ChildCategoryHistory.self).filter("id = %@", searchDetails!.id).first
                    category!.products.append(product.getRealmObject())
                }
                    
            } else {
                // Add to product history
                productItem = product.getRealmObject()
            }

        }

    }

}
