//
//  ReviewsModel.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 4/21/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation


struct ReviewsModel: Codable {
    var reviews: [Review]?
}

struct Review: Codable {
    var rating: String?
    var reviewComment: String?
    var reviewTitle: String?
}
