//
//  DiningHallCell.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 2/25/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class DiningHallCell: UITableViewCell {
    
    @IBOutlet weak var dinerImageView: UIImageView!
    @IBOutlet weak var dinerNameLabel: UILabel!
    @IBOutlet weak var dinerDescription: UILabel!
    @IBOutlet weak var dinerRatingView: CosmosView!
    @IBOutlet weak var addReviewButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dinerRatingView.rating = 3
    }
    
}
