//
//  MenuDetailViewController.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 3/27/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit

class MenuDetailViewController: UIViewController {
    
    @IBOutlet var menudetailTableView: UITableView!
    var menuItem: MenuModel?
    private var menuItemDictionary: [String: Any]?
    private let itemsToShow = ["calories", "caloriesFromFat", "fat", "saturatedFat", "transFat", "cholesterol", "carbohydrates", "dietaryFiber", "sugar", "protein", "sodium", "potassium", "portionSize"]
    private let savedFavoriteMenuItem = UserPreferences.shared.savedFavoriteMenuItem
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menudetailTableView.sectionHeaderHeight = UITableView.automaticDimension
        menudetailTableView.estimatedSectionHeaderHeight = 250
        title = "Nutritional Information"
        menuItemDictionary = menuItem?.dictionary
    }

    @objc private func addToFavorite(_ sender: UIButton) {
        
        if UserPreferences.shared.currentUser?.firstName?.count ?? 0 > 0 {
            if let menuItem = menuItem, let formalName = menuItem.formalName {
                if sender.titleLabel?.text == "Add to Favroite" {
                    UserPreferences.shared.savedFavoriteMenuItem = [menuItem]
                    sender.setTitle("Remove from Favroite", for: .normal)
                    Alert.shared.showAlert(title: "\(formalName) added to favroite", message: nil, on: self)
                } else {
                    UserPreferences.shared.removeFavorite(menuItem: menuItem)
                    sender.setTitle("Add to Favroite", for: .normal)
                    Alert.shared.showAlert(title: "\(formalName) removed to favroite", message: nil, on: self)
                }
            }
        } else {
            Alert.shared.showAlert(title: "Please log in to use this feature", message: "By logging in, you can easliy check your favorite item's avaibility", on: self)
        }
    }
}


extension MenuDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return MenuDetailTitles.allValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menudetail", for: indexPath) as? MenuDetailCell else {
            return UITableViewCell()
        }
        
        let menuItem = MenuDetailTitles.allValues[indexPath.row]
        cell.titleLabel?.text = menuItem.title
        cell.valueLabel?.text = menuItemDictionary?[menuItem.rawValue] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuDetailHeader") as? MenuDetailHeaderCell else {
            return UITableViewCell()
        }
        
        // Add placeholder image in default value
        if let menuItemImage = UIImage(named: "\(menuItem?.formalName ?? "")") {
            cell.menuItemImageView?.image = menuItemImage
        }
        cell.menuItemName.text = menuItem?.formalName
        cell.menuItemDescription.text = menuItem?.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "MenuDetailFooterCell") as? MenuDetailFooterCell else {
            return UITableViewCell()
        }
        
        cell.addToFavoriteButton.addTarget(self, action: #selector(addToFavorite(_:)), for: .touchUpInside)
        
        if let savedFavoriteMenuItem = savedFavoriteMenuItem, let menuItem = menuItem, savedFavoriteMenuItem.contains(menuItem) {
            cell.addToFavoriteButton.setTitle("Remove from Favroite", for: .normal)
        } else {
            cell.addToFavoriteButton.setTitle("Add to Favroite", for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

enum MenuDetailTitles: String {
    
    case calories = "calories"
    case caloriesFromFat = "caloriesFromFat"
    case fat = "fat"
    case saturatedFat = "saturatedFat"
    case transFat = "transFat"
    case cholesterol = "cholesterol"
    case carbohydrates = "carbohydrates"
    case dietaryFiber = "dietaryFiber"
    case sugar = "sugar"
    case protein = "protein"
    case sodium = "sodium"
    case potassium = "potassium"
    case portionSize = "portionSize"
    
    static let allValues = [calories, caloriesFromFat, fat, saturatedFat, transFat, cholesterol, carbohydrates, dietaryFiber, sugar, protein, sodium, potassium, portionSize]
    
    var title: String {
        switch self {
        case .calories:
            return "Calories"
        case .caloriesFromFat:
            return "Calories from fat"
        case .fat:
            return "Total fat"
        case .saturatedFat:
            return "Saturated fat"
        case .transFat:
            return "Trans fat"
        case .cholesterol:
            return "Cholesterol"
        case .carbohydrates:
            return "Total Carbohydrates"
        case .dietaryFiber:
            return "Fiber"
        case .sugar:
            return "Sugars"
        case .protein:
            return "Protein"
        case .sodium:
            return "Sodium"
        case .potassium:
            return "Potassium"
        case .portionSize:
            return "Serving size"
        }
    }
}

