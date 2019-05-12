//
//  MenuViewController.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 3/6/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    
    var menuItemsArray = [String : [MenuModel]]()
    private var currentMenuItemsArray = [String : [MenuModel]]() {
        willSet {
            menuSectionArray = [String] ((newValue.keys))
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    private let viewModel = MenuViewModel()
    @IBOutlet weak var menuTableView: UITableView!
    private var menuSectionArray = [String]()
    private var previousSearchText: String?
    private var currentSelectedIndex: IndexPath?
    var currentUser: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpSearchBar()
        menuSectionArray = [String] ((menuItemsArray.keys))
        sortMenuArray()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    private func sortMenuArray() {
        
        for menu in menuSectionArray {
            let sortedModels = menuItemsArray[menu]!.sorted(by: { $0.startTime?.compare($1.startTime!) == .orderedAscending })
            menuItemsArray[menu] = sortedModels
        }
        currentMenuItemsArray = menuItemsArray
        menuTableView.reloadData()
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.showsScopeBar = false // you can show/hide this dependant on your layout
        searchBar.placeholder = "Search Menu by Name"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "menudetail" {
            guard let detailMenuController = segue.destination as? MenuDetailViewController else {
                return
            }
           
            let section = menuSectionArray[currentSelectedIndex?.section ?? 0]
            let menuItem = currentMenuItemsArray[section]?[currentSelectedIndex?.row ?? 0]
            detailMenuController.menuItem = menuItem
            
        } else if segue.identifier == "menufilter" {
            
            guard let menuFilterViewController = segue.destination as? MenuFilterViewController else {
                return
            }
            
            menuFilterViewController.closure = { [weak self] filterDictionary in
                guard let weakSelf = self else { return }
                weakSelf.filterAndReload(filterDictionary: filterDictionary)
            }
        }
    }
    
    private func filterAndReload(filterDictionary: [String: Any]) {
        
        for (key, models) in currentMenuItemsArray {
            if  let caloriesCount = filterDictionary["maxCalories"] as? Int64 {
                currentMenuItemsArray[key] = filterByCalories(caloriesCount: caloriesCount, modelArray: models)
            }
            if  let dishesArray = filterDictionary["dishes"] as? [String], dishesArray.contains("Vegan") {
                currentMenuItemsArray[key] = veganFilter(modelArray: models)
            }
            if   let dishesArray = filterDictionary["dishes"] as? [String], dishesArray.contains("Vegetarian") {
                currentMenuItemsArray[key] = VegetarianFilter(modelArray: models)
            }
            if  let dishesArray = filterDictionary["dishes"] as? [String], dishesArray.contains("Mindful") {
                currentMenuItemsArray[key] = mindfulFilter(modelArray: models)
            }
            if  let allergensArray = filterDictionary["allergens"] as? [String], allergensArray.contains("Milk") {
                currentMenuItemsArray[key] = milkFilter(modelArray: models)
            }
            if  let allergensArray = filterDictionary["allergens"] as? [String], allergensArray.contains("Eggs") {
                currentMenuItemsArray[key] = eggFilter(modelArray: models)
            }
            if  let allergensArray = filterDictionary["allergens"] as? [String], allergensArray.contains("Wheat") {
                currentMenuItemsArray[key] = wheatFilter(modelArray: models)
            }
            if  let allergensArray = filterDictionary["Soybean"] as? [String], allergensArray.contains("Soybean") {
                currentMenuItemsArray[key] = soyabeanFilter(modelArray: models)
            }
            if  let allergensArray = filterDictionary["Soybean"] as? [String], allergensArray.contains("Gluten") {
                currentMenuItemsArray[key] = glutenFilter(modelArray: models)
            }
            
            if currentMenuItemsArray[key]?.count == 0 {
                currentMenuItemsArray.removeValue(forKey: key)
            }
            
        }
        
        self.menuTableView.reloadData()
        
    }
    
    private func filterByCalories(caloriesCount: Int64, modelArray: [MenuModel]) -> [MenuModel] {
        return modelArray.filter({ model -> Bool in
            Int64(model.calories ?? "0") ?? 0 < caloriesCount
        })
    }
    
    private func veganFilter(modelArray: [MenuModel]) -> [MenuModel] {
        return modelArray.filter({ model -> Bool in
            model.isVegan == true
        })
    }
    
    private func VegetarianFilter(modelArray: [MenuModel]) -> [MenuModel] {
        return modelArray.filter({ model -> Bool in
            model.isVegetarian == true
        })
    }
    
    private func mindfulFilter(modelArray: [MenuModel]) -> [MenuModel] {
        return modelArray.filter({ model -> Bool in
            model.isMindful == true
        })
    }
    
    private func milkFilter(modelArray: [MenuModel]) -> [MenuModel] {
        return modelArray.filter({ model -> Bool in
            model.allergens?.Milk != true
        })
    }
    
    private func eggFilter(modelArray: [MenuModel]) -> [MenuModel] {
        return modelArray.filter({ model -> Bool in
            model.allergens?.Eggs != true
        })
    }
    
    private func wheatFilter(modelArray: [MenuModel]) -> [MenuModel] {
        return modelArray.filter({ model -> Bool in
            model.allergens?.Wheat != true
        })
    }
    
    private func soyabeanFilter(modelArray: [MenuModel]) -> [MenuModel] {
        return modelArray.filter({ model -> Bool in
            model.allergens?.Soybean != true
        })
    }
    
    private func glutenFilter(modelArray: [MenuModel]) -> [MenuModel] {
        return modelArray.filter({ model -> Bool in
            model.allergens?.Gluten != true
        })
    }
    
}


extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuSectionArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menuSectionArray[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentMenuItemsArray[menuSectionArray[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell", for: indexPath) as? MenuItemCell else {
            return UITableViewCell()
        }
        
        if let menuItem = currentMenuItemsArray[menuSectionArray[indexPath.section]]?[indexPath.row] {
            if let menuItemName = menuItem.formalName {
                cell.menuName.text = menuItemName
            }
            if let totalCalories = menuItem.calories {
                cell.totalCalories.text = "Calories \(totalCalories)"
            }
            cell.menuDiscription.text = menuItem.description
            cell.menuImageView.image = UIImage(named: "\(menuItem.menuItemId ?? 0)")
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuDefaultHeader") as? MenuDefaultHeader else {
            return UITableViewCell()
        }
        
        cell.headerTitle?.text = menuSectionArray[section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedIndex = indexPath
        performSegue(withIdentifier: "menudetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Allow delete option only if User is Admin
        guard let isAdmin = currentUser?.isAdmin, isAdmin else {
            return
        }
        
        if editingStyle == .delete {
            // delete item at indexPath
            self.currentMenuItemsArray[self.menuSectionArray[indexPath.section]]?.remove(at: indexPath.row)
            
            guard let menuModelToDelete = self.currentMenuItemsArray[self.menuSectionArray[indexPath.section]]?[indexPath.row]
                else { return }
            APIManager.shared.deleteDocument(menuModelToDelete) { (isSuccess) in
                if let isSuccess = isSuccess, isSuccess {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
}


extension MenuViewController: UISearchBarDelegate {
    
    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentMenuItemsArray = menuItemsArray
        updateMenuItems(searchText)
        previousSearchText = searchText
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
    private func updateMenuItems(_ searchText: String) {
        if searchText.count <= 0 {
            return
        }
        for (key, value) in currentMenuItemsArray {
            let filteredValue = value.filter({($0.formalName?
                .localizedCaseInsensitiveContains(searchText))!})
            currentMenuItemsArray[key] = filteredValue
            
            if currentMenuItemsArray[key]?.count == 0 {
                currentMenuItemsArray.removeValue(forKey: key)
            }
        }
        
        menuTableView.reloadData()
    }
}

struct FilterFields {
    
    var isVegan: Bool?
    var isVegetarian: Bool?
    var isMindful: Bool?
    var Eggs: Bool?
    var Gluten: Bool?
    var Milk: Bool?
    var Soybean: Bool?
    var Wheat: Bool?
    
    
    init(filterModel: MenuModel, filterDic: [String: Any]) {
        
        self.isVegan = filterModel.isVegan
        self.isVegetarian = filterModel.isVegetarian
        self.isMindful = filterModel.isMindful
        self.Eggs = filterModel.allergens?.Eggs
        self.Gluten = filterModel.allergens?.Gluten
        self.Milk = filterModel.allergens?.Milk
        self.Soybean = filterModel.allergens?.Soybean
        self.Wheat = filterModel.allergens?.Wheat
        
        self.populateFilterFields(filterDic: filterDic)
        
    }
    
    mutating func populateFilterFields(filterDic: [String: Any]) {
        
        
        if let dishes = filterDic["dishes"] as? [String] {
            for dish in dishes {
                switch dish {
                case "Vegan":
                    isVegan = true
                case "Vegetarian":
                    isVegetarian = true
                case "Mindful":
                    isMindful = true
                default:
                    break
                }
            }
        }
        
        if let allergens = filterDic["allergens"] as? [String] {
            for allergen in allergens {
                switch allergen {
                case "Eggs":
                    Eggs = true
                case "Gluten":
                    Gluten = true
                case "Milk":
                    Milk = true
                case "Soybean":
                    Soybean = true
                case "Wheat":
                    Wheat = true
                default:
                    break
                }
            }
        }
    }
    
}
