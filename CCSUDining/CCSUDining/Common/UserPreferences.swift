//
//  UserPreferences.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 5/8/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation

class UserPreferences {
    
    private let FavoriteKey = "FavoriteKey"
    private let UserLoggedInKey = "UserLoggedInKey"
    private let AllMenuModels = "AllMenuModels"
    
    static let shared = UserPreferences()
    
    //Initializer access level change now
    private init(){}
    
    /** Saves the saved Favorite MenuItem */
    var savedFavoriteMenuItem: [MenuModel]? {
        get {
            if let favoriteMenuItems = UserDefaults.standard.object(forKey: FavoriteKey) as? Data {
                if let menuModels = try? JSONDecoder().decode([MenuModel].self, from: favoriteMenuItems) {
                    return menuModels
                }
            }
            // Returning default value if UserDefaults returns nil
            return nil
        }
        set(newValue) {
            if var newValue = newValue {
                if let prevouslySavedModels = savedFavoriteMenuItem, newValue.count == 1 {
                    newValue = prevouslySavedModels + newValue
                }
                if let encoded = try? JSONEncoder().encode(newValue) {
                    UserDefaults.standard.set(encoded, forKey: FavoriteKey)
                }
            }
        }
    }
    
    /** Saves the user Logged In */
    var currentUser: UserModel? {
        get {
            if let userModel = UserDefaults.standard.object(forKey: UserLoggedInKey) as? Data {
                if let menuModels = try? JSONDecoder().decode(UserModel.self, from: userModel) {
                    return menuModels
                }
            }
            // Returning default value if UserDefaults returns nil
            return nil
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: UserLoggedInKey)
            }
        }
    }
    
    /** Saves the saved all MenuItem */
    var savedAllMenuModels: [MenuModel]? {
        get {
            if let allMenuItems = UserDefaults.standard.object(forKey: AllMenuModels) as? Data {
                if let menuModels = try? JSONDecoder().decode([MenuModel].self, from: allMenuItems) {
                    return menuModels
                }
            }
            // Returning default value if UserDefaults returns nil
            return nil
        }
        set(newValue) {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: AllMenuModels)
            }
        }
    }
    
    
    func removeFavorite(menuItem: MenuModel) {
        if let savedFavoriteMenuItem = savedFavoriteMenuItem {
            self.savedFavoriteMenuItem = savedFavoriteMenuItem.filter() { $0 != menuItem }
        }
    }
    
}
