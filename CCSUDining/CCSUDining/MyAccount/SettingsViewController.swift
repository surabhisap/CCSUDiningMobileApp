//
//  SettingsViewController.swift
//  CCSUDining
//  https://firebase.google.com
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
                    
                    if let email = document.data()?["email"] {
                        self?.settingsArray?.append("\(email)")
                    }
                }
            }
            self?.settingsTableView.reloadData()
        }
    }
    
    @objc private func logOut() {
        
        UserPreferences.shared.currentUser = nil
        do {
            try Auth.auth().signOut()
            goToSignUpage()
        }
        catch let _ as NSError {
        }
    }
    
    private func goToSignUpage() {
        let signUpStoryBoard = UIStoryboard(name: "SignUp", bundle: nil)
        let myAccountViewController = signUpStoryBoard.instantiateViewController(withIdentifier: "SignUpOptions") as! SignUpOptionsViewController
        self.navigationController?.setViewControllers([myAccountViewController], animated: true)
    }
}
