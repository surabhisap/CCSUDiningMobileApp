//
//  DinerReviews.swift
//  CCSUDining
//  https://github.com/evgenyneu/Cosmos
//  Created by Surabhi Agnihotri on 4/15/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit
import Cosmos
import Firebase

class DinerReviewsViewController: UIViewController {
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var ratingTitle: InspectableUITextField!
    var dinerName: String?
    var dinerRating = "3"
    var closure: (() -> Void)?
    
    @IBOutlet weak var ratingDescription: InspectableUITextView!
    private var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Reviews for " + (DiningHallType(rawValue: dinerName ?? "")?.hallName ?? "")
        cosmosView.settings.starSize = 50
        cosmosView.rating = Double(dinerRating) ?? 3
        
        let viewReviewsButton = UIBarButtonItem(image: UIImage(named: "customerReviews"), style: .done, target: self, action: #selector(viewReviews))
        self.navigationItem.rightBarButtonItem  = viewReviewsButton
        db = Firestore.firestore()
    }
    
    @IBAction func submitRatingAction(_ sender: Any) {
   
        // Make API call to update Rating
        
        if cosmosView.rating > 0 {
            submitReview()
            navigationController?.popViewController(animated: true)
            guard let closure = closure else {return}
            closure()
        } else {
            Alert.shared.showAlert(title: "Please add your review", message: nil, on: self)
        }
    }
    
    @objc private func viewReviews() {
        performSegue(withIdentifier: "viewDinerReviews", sender: nil)
    }
    
    private func submitReview() {
        guard let dinerName = dinerName else { return }
        db.collection("DiningHalls").document(dinerName).updateData([
            "reviews": FieldValue.arrayUnion([["rating": "\(Int(cosmosView.rating))", "reviewComment": ratingDescription.text!, "reviewTitle": ratingTitle.text!]])
            ])

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewDinerReviews" {
           guard let viewReviewsVC = segue.destination as? ViewDinerReviews else {
                return
            }
            viewReviewsVC.selectedDiner = dinerName
        }
    }
}

extension DinerReviewsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension DinerReviewsViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
