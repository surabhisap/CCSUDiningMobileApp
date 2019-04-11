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
        APIManager.shared.fetchCollection(collectionName: "2019-04-10", completionHandler: completionHandler)
    }
    
}
