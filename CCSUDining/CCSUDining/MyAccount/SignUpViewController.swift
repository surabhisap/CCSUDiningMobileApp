//
//  SignUpViewController.swift
//  CCSUDining
//  https://firebase.google.com
//  Created by Surabhi Agnihotri on 4/17/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    
    private var user : User?
    private var errorCount = [String]()
    private var errorMessage = String()
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        signUp()
    }
    
    // Logic for sign up
    func signUp() {
        errorCount.removeAll()
        validateEmail()
        validatePasswordsEmpty()
        validatePaswordsMatch()
        
        if(errorCount.isEmpty){
            createUserInDB()
        } else{
            errorMessage = errorCount.joined(separator: "\n")
        }
    }
    
    //Handels go to next page
    func goToNextPage() {
        let signUpStoryBoard = UIStoryboard(name: "SignUp", bundle: nil)
        guard let myAccountViewController = signUpStoryBoard.instantiateViewController(withIdentifier: "myAccount") as? MyAccountViewController else { return }
        self.navigationController?.setViewControllers([myAccountViewController], animated: false)
    }
    
}

//Textfield delegates
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// Database interaction
extension SignUpViewController {

    func createUserInDB()
    {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text else{ return }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error ) in
            if error != nil {
                Alert.shared.showAlert(title: "Email address is already in use, please use another one", message: nil, on: self, alertActions: [UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)])
                return
            }
            
            guard let userID = Auth.auth().currentUser?.uid else { return }
            Firestore.firestore().collection("user").document(userID).setData([
                "email" : email,
                "firstName" : firstName,
                "lastName" : lastName,
                "password": password,
                "isAdmin": false,
                "dateCreated": FieldValue.serverTimestamp()
                
                ], completion: { (error) in
                    if error == nil {
                        self.fetchUserProfile(for: email)
                    }
            })
        })
    }
    
    private func fetchUserProfile(for email: String) {
        APIManager.shared.fetchCurrentUser { [weak self] (userModel) in
            UserPreferences.shared.currentUser = userModel
            self?.goToNextPage()
        }
    }
}

// Validate fields
extension SignUpViewController {
    
    func validateEmail() {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: emailTextField.text!)
        if(emailTextField.text == ""){
            errorCount.append("Empty email field");
        }
        if(emailTest != true){
            errorCount.append("Incorrect email format");
        }
    }
    
    func validatePaswordsMatch() {
        if(passwordTextField.text != repasswordTextField.text){
            errorCount.append("Password fields are not matching");
        }
    }
    
    func validatePasswordsEmpty() {
        if passwordTextField.text == "" && repasswordTextField.text == "" {
            errorCount.append("Password fields are empty");
        }
    }
}
