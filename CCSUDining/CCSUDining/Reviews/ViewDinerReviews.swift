//
//  ViewDinerReviews.swift
//  CCSUDining
//  https://github.com/evgenyneu/Cosmos
//  Created by Surabhi Agnihotri on 4/21/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit


class ViewDinerReviews: UIViewController {
    
    private var dinerReviews = [String: ReviewsModel]()
    var selectedDiner: String?
    @IBOutlet var reviewsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDinerReviews()
    }
    
    private func fetchDinerReviews() {
        
        APIManager().fetchDinerReviews { [weak self] (dinerReviews) in
            self?.dinerReviews = dinerReviews
            self?.reviewsTable.reloadData()
        }
    }
}

extension ViewDinerReviews: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let selectedDiner = selectedDiner, let reviews = (dinerReviews[selectedDiner])?.reviews {
            return reviews.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dinerReviewCell", for: indexPath) as? DinerReviewCell else {
            return UITableViewCell()
        }
        if let selectedDiner = selectedDiner, let dinerReviews = dinerReviews[selectedDiner]?.reviews  {
            cell.reviewTitle.text = dinerReviews[indexPath.row].reviewTitle
            cell.reviewComment.text = dinerReviews[indexPath.row].reviewComment
            cell.ratingCosmosView.rating = Double(dinerReviews[indexPath.row].rating ?? "3") ?? 3
        }
        return cell
    }
    
}
