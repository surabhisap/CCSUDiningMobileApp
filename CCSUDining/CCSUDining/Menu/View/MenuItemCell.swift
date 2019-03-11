//
//  MenuItemCell.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 3/6/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit

class MenuItemCell: UITableViewCell {
    
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var menuDiscription: UILabel!
    @IBOutlet weak var totalCalories: UILabel!
    
    override func awakeFromNib() {

    }
}

