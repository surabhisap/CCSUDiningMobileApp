//
//  LoginViewController.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 4/17/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MyAccountViewController: UIViewController {
    
    private var handle: AuthStateDidChangeListenerHandle?
    private let myAccountItems = ["Personal Details", "Favorites", "App Feedback", "About Us"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButton = UIBarButtonItem(image: UIImage(named: "settingsIcon"), style: .plain, target: self, action: #selector(showSettigs))
        self.navigationController?.navigationItem.rightBarButtonItem  = barButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Hello \(UserPreferences.shared.currentUser?.firstName ?? "")"

    }
    
    @objc func showSettigs(){
        performSegue(withIdentifier: "settings", sender: nil)
    }
    
    private func goToSignUpage() {
        let signUpStoryBoard = UIStoryboard(name: "SignUp", bundle: nil)
        let myAccountViewController = signUpStoryBoard.instantiateViewController(withIdentifier: "SignUpOptions") as! SignUpOptionsViewController
        UserPreferences.shared.currentUser = UserModel()
        self.navigationController?.setViewControllers([myAccountViewController], animated: true)
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
}


extension MyAccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAccountItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyAccountCell", for: indexPath) as? MyAccountCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = myAccountItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            performSegue(withIdentifier: "personalDetails", sender: nil)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "favorite", sender: nil)
        } else if indexPath.row == 2 {
            performSegue(withIdentifier: "feedback", sender: nil)
        } else if indexPath.row == 3 {
            performSegue(withIdentifier: "aboutUs", sender: nil) 
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "MyAccountFooter") as? MyAccountFooterCell else {
            return UITableViewCell()
        }
        
        cell.logoutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    
}
