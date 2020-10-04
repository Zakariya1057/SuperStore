//
//  SortFilterViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 29/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

enum RefineType {
    case sort
    case category
    case dietary
    case brand
}

enum OrderType {
    case asc
    case desc
}

class RefineSortModel: RefineModel {
    var order: OrderType
    var sort: String
    
    init(name: String, selected: Bool, quantity: Int?, order: OrderType, sort: String) {
        self.order = order
        self.sort = sort
        super.init(name: name, selected: selected,quantity: quantity)
    }
}

class RefineModel: Equatable {
    
    var name: String
    var quantity: Int?
    var selected: Bool = false
    
    init(name: String, selected: Bool, quantity: Int?){
        self.name = name
        self.selected = selected
        self.quantity = quantity
    }
    
    static func == (lhs: RefineModel, rhs: RefineModel) -> Bool {
        return lhs.name ==  rhs.name
    }
}
struct RefineOptionModel {
    var header: String
    var values: [RefineModel]
    var type: RefineType
}

struct RefineHistoryModel {
    var sort: RefineSortModel?
    var category: RefineModel?
    var dietary: [RefineModel]?
    var brand: RefineModel?
}

protocol RefineSelectedDelegate {
    func applyOptions(sort: RefineSortModel?, category: RefineModel?, brand: RefineModel?, dietary:[RefineModel])
    func clearAllOptions()
}

class RefineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var refineTableView: UITableView!
    
    var delegate: RefineSelectedDelegate?
    
    var selectedSort: RefineSortModel?
    var selectedCategory: RefineModel?
    var selectedBrand: RefineModel?
    var selectedDietary: [RefineModel] = []
    
    var refineHistory: RefineHistoryModel?
    
    var filters: [RefineOptionModel] = []
    
    var options:[RefineOptionModel] = [
        
        RefineOptionModel(
            header: "Sort By",
            values: [
                RefineSortModel(name: "Rating - High to Low", selected: false,quantity: nil, order: .desc, sort: "rating"),
                RefineSortModel(name: "Rating - Low to High", selected: false,quantity: nil, order: .asc, sort: "rating"),
                RefineSortModel(name: "Price - High to Low", selected: false,quantity: nil, order: .desc, sort: "price"),
                RefineSortModel(name: "Price - Low to High", selected: false,quantity: nil, order: .asc, sort: "price"),
                
            ],
            type: .sort
        ),

        
        RefineOptionModel(
            header: "Dietary & LifeStyle",
            values: [
                RefineModel(name: "Vegetarian", selected: false,quantity: nil),
                RefineModel(name: "Vegan", selected: false,quantity: nil),
                RefineModel(name: "No Peanuts", selected: false,quantity: nil),
                RefineModel(name: "No Shellfish", selected: false,quantity: nil),
                RefineModel(name: "No Gluten", selected: false,quantity: nil),
                RefineModel(name: "No Milk", selected: false,quantity: nil),
                RefineModel(name: "No Lactose", selected: false,quantity: nil),
                RefineModel(name: "No Egg", selected: false,quantity: nil),
                RefineModel(name: "Low Salt", selected: false,quantity: nil),
                RefineModel(name: "Low Fat", selected: false,quantity: nil),
            ],
            type: .dietary
        ),

    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: K.Sections.HomeHeader.SectionNibName, bundle: nil)
        refineTableView.register(nib, forHeaderFooterViewReuseIdentifier: K.Sections.HomeHeader.SectionIdentifier)
        
        refineTableView.register(UINib(nibName: K.Cells.RefineCell.CellNibName, bundle: nil), forCellReuseIdentifier:K.Cells.RefineCell.CellIdentifier)
        
        refineTableView.dataSource = self
        refineTableView.delegate = self
        // Do any additional setup after loading the view.
        
        addLoadedFilters()
        setLastOptions()
        
    }
    
    func addLoadedFilters(){
        if filters.count > 0 {
            var categories = filters[0]
            var brands = filters[1]
        
            if categories.values.count > 0 {
                categories.values = categories.values.sorted { (a, b) -> Bool in
                    a.quantity ?? 0 > b.quantity ?? 0
                }
                options.insert(categories, at: 1)
            }
            
            if brands.values.count > 0 {
                brands.values = brands.values.sorted { (a, b) -> Bool in
                    a.quantity ?? 0 > b.quantity ?? 0
                }
                options.insert(brands, at: 2)
            }
            
            refineTableView.reloadData()
        }
    }
    
    func setLastOptions(){
        if refineHistory != nil {
            
            let items = options.flatMap { $0.values }
            
            for item in items {
                if (refineHistory?.category == item) || (refineHistory?.sort == item) || (refineHistory?.brand == item) {
                    
                    if refineHistory?.category == item {
                        selectedCategory = item
                    }
                    
                    if refineHistory?.sort == item {
                        selectedSort = item as? RefineSortModel
                    }
                    
                    if refineHistory?.brand == item {
                        selectedBrand = item
                    }
                    
                    item.selected = true
                }
                
                for dietaryHistory in refineHistory?.dietary ?? [] {
                    
                    print(dietaryHistory)
                    if dietaryHistory == item {
                        item.selected = true
                        selectedDietary.append(item)
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

extension RefineViewController {
    
    @IBAction func donePressed(_ sender: Any) {
        print(selectedDietary)
        self.delegate?.applyOptions(sort: selectedSort, category: selectedCategory,brand: selectedBrand, dietary: selectedDietary)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearAllPressed(_ sender: Any) {
        self.delegate?.clearAllOptions()
        self.dismiss(animated: true, completion: nil)
    }
    
    func optionSelected(section: Int, row: Int) {
        deselectSection(section: section, row: row)
        refineTableView.reloadData()
    }

    func deselectSection(section: Int, row: Int){
        
//        let singleSelect = section > 3 ? true : false
        let singleSelect = options[section].type == .dietary ? false : true
        
        for (rowIndex, item) in options[section].values.enumerated() {
            
            if singleSelect == false {
                
                if rowIndex == row {
                    
                    if options[section].type == .dietary {
                        
                        var found: Bool = false
                        
                        for (index,item1) in selectedDietary.enumerated(){
                            if item == item1 {
                                selectedDietary.remove(at:index )
                                found = true
                                break
                            }
                        }
                        
                        if !found {
                            print(item)
                            selectedDietary.append(item)
                        }

                    }
                    
                    options[section].values[row].selected = !options[section].values[row].selected
                }
                
            } else {
                
                if rowIndex != row {
                    options[section].values[rowIndex].selected = false
                } else {
                    
                    if options[section].type == .sort {
                        if options[section].values[row].selected {
                            selectedSort = nil
                        } else {
                            selectedSort = item as? RefineSortModel
                        }
                    }
                    
                    if options[section].type == .category {
                        if options[section].values[row].selected {
                            selectedCategory = nil
                        } else {
                            selectedCategory = item
                        }
                    }
                    
                    if options[section].type == .brand {
                        if options[section].values[row].selected {
                            selectedBrand = nil
                        } else {
                            selectedBrand = item
                        }
                    }
                    
                    options[section].values[row].selected = !options[section].values[row].selected
                    
                }
                
            }
            
        }
        
    }
    
}

extension RefineViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        optionSelected(section: indexPath.section, row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = options[section].header
        let header = refineTableView.dequeueReusableHeaderFooterView(withIdentifier:  K.Sections.HomeHeader.SectionIdentifier) as! HomeSectionHeader
        header.headingLabel.text = title
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options[section].values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = refineTableView.dequeueReusableCell(withIdentifier:K.Cells.RefineCell.CellIdentifier , for: indexPath) as! RefineTableViewCell
        
        let item = options[indexPath.section].values[indexPath.row]
        
        cell.row = indexPath.row
        cell.section = indexPath.section
        
        cell.selectedOption = item.selected
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        var quantity: String = ""
        
        if item.quantity != nil {
            quantity = "(\(String(item.quantity!)))"
        }
        
        cell.name = "\(item.name) \(quantity)"
        
        cell.configureUI()
        
        return cell
    }
    
}
