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
    let viewModel = MenuViewModel()
    @IBOutlet weak var menuTableView: UITableView!
    var menuSectionArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        menuSectionArray = [String] ((menuItemsArray?.keys)!)
        sortMenuArray()
    }
    
    private func sortMenuArray() {
        
        for menu in menuSectionArray {
            let sortedModels = menuItemsArray![menu]!.sorted(by: { $0.startTime?.compare($1.startTime!) == .orderedDescending })
            menuItemsArray![menu] = sortedModels
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
        
        return menuItemsArray?[menuSectionArray[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell", for: indexPath) as? MenuItemCell else {
            return UITableViewCell()
        }
        
        if let menuItem = menuItemsArray?[menuSectionArray[indexPath.section]]![indexPath.row], let menuItemName = menuItem.formalName, let menuItemDiscription = menuItem.description, let totalCalories = menuItem.calories {
            cell.menuName.text = menuItemName
            cell.menuDiscription.text = menuItemDiscription
            cell.totalCalories.text = "Calories \(totalCalories)"
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        /*if section == 0 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
            return headerCell
        }*/
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuDefaultHeader") as? MenuDefaultHeader else {
            return UITableViewCell()
        }
        
        cell.headerTitle?.text = menuSectionArray[section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        /*if section == 0 {
            return 50
        }*/
        return 40
    }
}
