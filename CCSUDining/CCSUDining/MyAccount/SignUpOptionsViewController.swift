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
        // Do any additional setup after loading the view, typically from a nib.
        
        if UserPreferences.shared.currentUser?.email?.count ?? 0 > 0 {
            goToStudentPage()
        }
    }


    private func goToStudentPage() {
        let signUpStoryBoard = UIStoryboard(name: "SignUp", bundle: nil)
        let myAccountViewController = signUpStoryBoard.instantiateViewController(withIdentifier: "myAccount") as! MyAccountViewController
        self.navigationController?.setViewControllers([myAccountViewController], animated: false)
        self.navigationItem.title = "Hello \(UserPreferences.shared.currentUser?.firstName ?? "")"
    }
}

