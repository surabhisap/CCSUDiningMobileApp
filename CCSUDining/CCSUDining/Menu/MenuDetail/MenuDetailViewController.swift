//
//  MenuDetailViewController.swift
//  CCSUDining
//
//  Created by Anurag Pandey on 3/27/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit

class MenuDetailViewController: UIViewController {
    
    var menuItem: MenuModel?
    private var menuItemDictionary: [String: Any]?
    private let itemsToShow = ["calories", "caloriesFromFat", "fat", "saturatedFat", "transFat", "cholesterol", "carbohydrates", "dietaryFiber", "sugar", "protein", "sodium", "potassium", "portionSize"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nutritional Information"
        menuItemDictionary = menuItem?.dictionary
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

