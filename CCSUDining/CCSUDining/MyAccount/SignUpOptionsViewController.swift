//
//  SecondViewController.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 2/21/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import UIKit

class SignUpOptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserPreferences.shared.currentUser?.email?.count ?? 0 > 0 {
            goToMyAccountPage()
        }
    }


    private func goToMyAccountPage() {
        let signUpStoryBoard = UIStoryboard(name: "SignUp", bundle: nil)
        guard let myAccountViewController = signUpStoryBoard.instantiateViewController(withIdentifier: "myAccount") as? MyAccountViewController else { return }
        self.navigationController?.setViewControllers([myAccountViewController], animated: false)
        self.navigationItem.title = "Hello \(UserPreferences.shared.currentUser?.firstName ?? "")"
    }
}

