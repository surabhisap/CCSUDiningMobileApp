//
//  MenuModel.swift
//  CCSUDining
//  Created by Surabhi Agnihotri on 2/27/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct MenuModel: Codable, Equatable {
    
    var allergens: Allergerns?
    var menuItemId: Int64?
    var dining_hall: String?
    var formalName: String?
    var description: String?
    var calories: String?
    var caloriesFromFat: String?
    var fat: String?
    var saturatedFat: String?
    var transFat: String?
    var cholesterol: String?
    var carbohydrates: String?
    var dietaryFiber: String?
    var sugar: String?
    var protein: String?
    var sodium: String?
    var potassium: String?
    var portionSize: String?
    var number: String?
    var meal: String?
    var startTime: Timestamp?
    var endTime: Timestamp?
    var isVegan: Bool?
    var isVegetarian: Bool?
    var isMindful: Bool?
    
    static func == (lhs: MenuModel, rhs: MenuModel) -> Bool {
        return lhs.menuItemId == rhs.menuItemId
    }
}

struct Allergerns: Codable {
    var Eggs: Bool?
    var Gluten: Bool?
    var Milk: Bool?
    var Soybean: Bool?
    var Wheat: Bool?
}
