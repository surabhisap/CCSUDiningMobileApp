//
//  FirstViewController.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 2/21/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import UIKit

class DiningHallViewController: UIViewController {
    
    let viewModel = DinerViewModel()
    var diningHallArray = [String]()
    var menuArray = [String: [MenuModel]]()
    var selectedDinerIndex = 0
    @IBOutlet weak var diningTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewModel.getMenuForToday(completionHandler: { (menuModelArray) in
            self.menuArray = menuModelArray
            self.diningHallArray = [String] (menuModelArray.keys)
            self.diningTableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuSegue" {
            if let destinationVC = segue.destination as? MenuViewController {
                
                if let menuArray = menuArray[diningHallArray[selectedDinerIndex]]?.group(by: { $0.meal ?? "" }) {
                    destinationVC.menuItemsArray = menuArray
                }
            }
        }
    }
}


extension DiningHallViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return diningHallArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "diningHallCell", for: indexPath) as? DiningHallCell else {
            return UITableViewCell()
        }
        
        cell.dinerNameLabel.text = DiningHallType(rawValue: diningHallArray[indexPath.row])?.hallName
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDinerIndex = indexPath.row
        performSegue(withIdentifier: "menuSegue", sender: self)
    }
}

enum DiningHallType: String {
    
    case hilltop_cafe = "hilltop_cafe"
    case memorial_hall = "memorial_hall"
    case devils_den = "devils_den"
    
    var hallName: String {
        switch self {
        case .hilltop_cafe:
            return "Hilltop Cafe"
        case .memorial_hall:
            return "Memorial Hall"
        case .devils_den:
            return "Devil's Den"
        }
    }
    
}
