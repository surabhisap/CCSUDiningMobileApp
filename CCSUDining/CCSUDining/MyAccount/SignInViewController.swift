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
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAttributeToForgotPasswordButton()
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
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        
        var emailTextField: UITextField?
        let alertController = UIAlertController(title: "Password Recovery", message: "Please enter your email address", preferredStyle: .alert)
        let resetPasswordAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            guard let email = emailTextField?.text, email.count > 0 else {
                return
            }
            
            Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
                if (error == nil) {
                    Alert.shared.showAlert(title: "Password reset", message: "Please check your inbox to reset your password", on: self)
                } else {
                     Alert.shared.showAlert(title: "Incorrect email addresst", message: "Please re-try with the email you registered with", on: self)
                }
            })
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in }
        alertController.addAction(resetPasswordAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textField) -> Void in
            emailTextField = textField
            emailTextField?.placeholder = "Enter your email address"
        }
        present(alertController, animated: true, completion: nil)
        
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)}
    
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
    
    private func addAttributeToForgotPasswordButton() {
        
        let forgotPasswordAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        
        let forgotPasswordAttributeString = NSMutableAttributedString(string: "Forgot Password?",
                                                                      attributes: forgotPasswordAttributes)
        forgotPasswordButton.setAttributedTitle(forgotPasswordAttributeString, for: .normal)
    }
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
