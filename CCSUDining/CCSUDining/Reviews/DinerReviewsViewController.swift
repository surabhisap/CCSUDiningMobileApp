//
//  DinerReviews.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 4/15/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class DinerReviewsViewController: UIViewController {
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var ratingTitle: InspectableUITextField!
    
    @IBOutlet weak var ratingDescription: InspectableUITextView!
    var dinnerName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Reviews for \(dinnerName ?? "")"
        cosmosView.settings.starSize = 50
        cosmosView.rating = 0
        
    }
    
    @IBAction func submitRatingAction(_ sender: Any) {
   
        // Make API call to update Rating
        
        if cosmosView.rating > 0 {
            navigationController?.popViewController(animated: true)
        } else {
            Alert.shared.showAlert(title: "Please add your review", message: nil, on: self)
        }
    }
}
