//
//  SettingsViewController.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 4/17/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    @IBOutlet var settingsTableView: UITableView!
    private let db = Firestore.firestore()
    private let uid = Auth.auth().currentUser!.uid
    
    private var settingsArray: [String]?
    
    private let settingsLableArray = ["Name", "User Name"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserDetais()
        
    }
    
    private func fetchUserDetais() {
        let appUser = db.collection("user").document(uid)
        appUser.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                if let firstName = document.data()?["firstName"],  let lastName = document.data()?["lastName"] {
                    self?.settingsArray = ["\(firstName) \(lastName)"]
                    
                    if let username = document.data()?["username"] {
                        self?.settingsArray?.append("\(username)")
                    }
                }
            }
            self?.settingsTableView.reloadData()
        }
    }
    
    @objc private func logOut() {
        
        do {
            try Auth.auth().signOut()
            goToSignUpage()
        }
        catch let signoutError as NSError {
            debugPrint("error: \(signoutError) " )
        }
    }
    
    private func goToSignUpage() {
        let signUpStoryBoard = UIStoryboard(name: "SignUp", bundle: nil)
        let myAccountViewController = signUpStoryBoard.instantiateViewController(withIdentifier: "SignUpOptions") as! SignUpOptionsViewController
        self.navigationController?.setViewControllers([myAccountViewController], animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settingsArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
        
        if let settingsArray = settingsArray {
            cell.titleLable.text = settingsLableArray[indexPath.row]
            cell.titleValue.text = settingsArray[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "settingsFooter") as? SettingsFooterCell else {
            return UITableViewCell()
        }
        
        cell.logoutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 50
    }
    
}
