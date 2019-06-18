//
//  DinerViewModel.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 3/6/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation

class DinerViewModel {
    
    func getMenuForToday(completionHandler: @escaping (([String: [MenuModel]]) -> Void)) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        APIManager.shared.fetchCollection(collectionName: currentDate, completionHandler: completionHandler)
    }
    
}
