//
//  UserModel.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 5/6/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    var firstName: String?
    var lastName: String?
    var email: String?
    var isAdmin: Bool?
}
