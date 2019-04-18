//
//  SignInViewController.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 4/17/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func signInAction(_ sender: Any) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text
            else {
                print ("Incorrect details entered")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            if error != nil{
                print(error as Any)
                return
            }
            else{
                self?.goToHomePage()
                print("User Logged In")
            }
        })
    }
    
    private func goToHomePage() {
        let signUpStoryBoard = UIStoryboard(name: "SignUp", bundle: nil)
        let myAccountViewController = signUpStoryBoard.instantiateViewController(withIdentifier: "myAccount") as! MyAccountViewController
        self.navigationController?.setViewControllers([myAccountViewController], animated: false)
    }
}

