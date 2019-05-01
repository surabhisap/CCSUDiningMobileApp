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
        
        APIManager.shared.fetchDummyDate { (dateString) in
            if let dateString = dateString as? String, dateString.count > 0 {
                APIManager.shared.fetchCollection(collectionName: dateString, completionHandler: completionHandler)
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd"
                let currentDate = dateFormatter.string(from: Date())
                APIManager.shared.fetchCollection(collectionName: currentDate, completionHandler: completionHandler)
            }
        }
    }
    
}
