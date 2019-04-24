//
//  DinerReviewCell.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 4/23/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class DinerReviewCell: UITableViewCell {
    
    @IBOutlet var reviewTitle: UILabel!
    @IBOutlet var reviewComment: UILabel!
    @IBOutlet var ratingCosmosView: CosmosView!
    
}
