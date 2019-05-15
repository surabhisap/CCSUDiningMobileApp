//
//  FavoriteViewController.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri  on 5/9/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favoriteTableView: UITableView!
    private var favotiteMenuItems: [MenuModel]?
    private let savedAllMenuModels = UserPreferences.shared.savedAllMenuModels
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Favorites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favotiteMenuItems = UserPreferences.shared.savedFavoriteMenuItem
        favoriteTableView.reloadData()
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favotiteMenuItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let favoriteCell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }
        
        if let menuItem = favotiteMenuItems?[indexPath.row], let menuItemName = menuItem.formalName, let totalCalories = menuItem.calories {
            favoriteCell.menuName.text = menuItemName
            if let menuItemDiscription = menuItem.description {
                favoriteCell.menuDiscription.text = menuItemDiscription
            }
            favoriteCell.totalCalories.text = "Calories \(totalCalories)"
            favoriteCell.menuImageView.image = UIImage(named: "\(menuItem.formalName ?? "")")
            
        }
        
        return favoriteCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let favoriteMenuItem = favotiteMenuItems?[indexPath.row], let formalName = favoriteMenuItem.formalName {
            var alertText = "Sorry, \(formalName) is not available today"
            if let savedAllMenuModels = savedAllMenuModels, savedAllMenuModels.contains(favoriteMenuItem), let hallName = DiningHallType(rawValue: favoriteMenuItem.dining_hall ?? "")?.hallName {
                alertText = "\(formalName) is available today in \(hallName)"
            }
            Alert.shared.showAlert(title: alertText, message: nil, on: self)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // delete item at indexPath
            self.favotiteMenuItems?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserPreferences.shared.savedFavoriteMenuItem = favotiteMenuItems
        }
    }
    
}
