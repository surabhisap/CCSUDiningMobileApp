//
//  PersonalDetailsViewController.swift
//  CCSUDining
//
//  Created by Surabhi on 5/10/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit

class PersonalDetailsViewController: UIViewController {
    
    private let personalDetails = ["First Name", "Last Name"]
    private var isEditMode = false
    @IBOutlet weak var detailsTableView: UITableView!
    private var currentUser = UserPreferences.shared.currentUser
    private var userDictionary = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveEditButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(saveEdit))
        self.navigationItem.rightBarButtonItem  = saveEditButton
    }
    
    @objc func saveEdit() {
        
        view.endEditing(true)
        isEditMode.toggle()
        if isEditMode {
            self.navigationItem.rightBarButtonItem?.title = "Save"
            detailsTableView.reloadData()
        } else {
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            saveUser { [weak self] in
                self?.detailsTableView.reloadData()
            }
        }
    }
    
    private func saveUser(completionHandler: @escaping (() -> Void)) {

        APIManager.shared.updateUser(userDictionary) { (success) in
            if success {
                Alert.shared.showAlert(title: "Successfully updated details", message: nil, on: self)
                APIManager.shared.fetchCurrentUser(completionHandler: { [weak self] (currentUser) in
                    self?.currentUser = currentUser
                    UserPreferences.shared.currentUser = currentUser
                    completionHandler()
                })
            } else {
                  Alert.shared.showAlert(title: "Error", message: "Update failed, please try again", on: self)
            }
        }
    }
        
       
    
}

extension PersonalDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return personalDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personalDetailsCell", for: indexPath) as? PersonalDetailsCell else {
            return UITableViewCell()
        }
        cell.detailsLabel.text = personalDetails[indexPath.row]
        cell.detailsTextField.isUserInteractionEnabled = isEditMode
        cell.detailsTextField.tag = indexPath.row
        
        switch indexPath.row {
        case 0:
            cell.detailsTextField.text = currentUser?.firstName
        case 1:
            cell.detailsTextField.text = currentUser?.lastName
        case 2:
            cell.detailsTextField.text = currentUser?.email
        default:
            break
        }
        
        if isEditMode {
            cell.detailsTextField.borderWidth = 1
            cell.detailsTextField.cornerRadius = 5
        } else {
            cell.detailsTextField.borderWidth = 0
            cell.detailsTextField.cornerRadius = 0
        }
       
        return cell
    }
    
}


extension PersonalDetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            userDictionary["firstName"] = textField.text
        case 1:
            userDictionary["lastName"] = textField.text
        case 3:
            userDictionary["email"] = textField.text
        default:
            break
        }
    }
}
