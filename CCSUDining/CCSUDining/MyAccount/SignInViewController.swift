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
        
        guard let email = emailTextField.text, email.count > 0, let password = passwordTextField.text, password.count > 0
            else {
                Alert.shared.showAlert(title: "Please enter your details", message: nil, on: self)
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            if error != nil{
                print(error as Any)
                return
            }
            else{
                guard let email = user?.user.email else { return }
                self?.fetchUserProfile(for: email)
                print("User Logged In")
            }
        })
    }
    
    private func fetchUserProfile(for email: String) {
        
        APIManager.shared.fetchCurrentUser { [weak self] (userModel) in
        UserPreferences.shared.currentUser = userModel
           self?.goToStudentPage()
        }

    }
    
    private func goToStudentPage() {
        let signUpStoryBoard = UIStoryboard(name: "SignUp", bundle: nil)
        let myAccountViewController = signUpStoryBoard.instantiateViewController(withIdentifier: "myAccount") as! MyAccountViewController
        self.navigationController?.setViewControllers([myAccountViewController], animated: false)
    }
    
    private func goToAdminPage() {
        let signUpStoryBoard = UIStoryboard(name: "SignUp", bundle: nil)
        let myAccountViewController = signUpStoryBoard.instantiateViewController(withIdentifier: "myAccount") as! MyAccountViewController
        self.navigationController?.setViewControllers([myAccountViewController], animated: false)
    }
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
