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
    
    var menuItemsArray: [String : [MenuModel]]?
    private var currentMenuItemsArray: [String : [MenuModel]]?
    @IBOutlet weak var searchBar: UISearchBar!
    private let viewModel = MenuViewModel()
    @IBOutlet weak var menuTableView: UITableView!
    private var menuSectionArray = [String]()
    private var previousSearchText: String?
    private var currentSelectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpSearchBar()
        menuSectionArray = [String] ((menuItemsArray?.keys)!)
        sortMenuArray()
    }
    
    private func sortMenuArray() {
        
        for menu in menuSectionArray {
            let sortedModels = menuItemsArray![menu]!.sorted(by: { $0.startTime?.compare($1.startTime!) == .orderedAscending })
            menuItemsArray![menu] = sortedModels
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
            let menuItem = currentMenuItemsArray?[section]?[currentSelectedIndex?.row ?? 0]
            detailMenuController.menuItem = menuItem
            
        }
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
        
        return currentMenuItemsArray?[menuSectionArray[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell", for: indexPath) as? MenuItemCell else {
            return UITableViewCell()
        }
        
        if let menuItem = currentMenuItemsArray?[menuSectionArray[indexPath.section]]![indexPath.row], let menuItemName = menuItem.formalName, let menuItemDiscription = menuItem.description, let totalCalories = menuItem.calories {
            cell.menuName.text = menuItemName
            cell.menuDiscription.text = menuItemDiscription
            cell.totalCalories.text = "Calories \(totalCalories)"
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
}


extension MenuViewController: UISearchBarDelegate {
    
    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentMenuItemsArray = menuItemsArray
        updateMenuItems(searchText)
        menuTableView.reloadData()
        previousSearchText = searchText
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
    private func updateMenuItems(_ searchText: String) {
        if searchText.count <= 0 {
            return
        }
        for (key, value) in currentMenuItemsArray! {
            let filteredValue = value.filter({($0.formalName?
                .localizedCaseInsensitiveContains(searchText))!})
            currentMenuItemsArray![key] = filteredValue
        }
    }
}
