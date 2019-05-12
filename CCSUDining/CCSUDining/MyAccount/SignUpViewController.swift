//
//  SignUpViewController.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 4/17/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    var user : User?
    
    // Fields Declaration
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    
    var errorsArray = [String]()
    
    var errorMessage = String()
    
    //Method for alert box when one of the fields were formmated wrong ------ Olek
    func generalAlert(){
        let alert = UIAlertController(title: "Warning", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Correct It", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Alert box for a situation when email is already exists in the database
    func emailExistsAlert(){
        let alert = UIAlertController(title: "Warning", message: "Typed email address is already in use, please input another one", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Change It", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Impelmenation for Sign Up button
    @IBAction func signUpBtn(_ sender: UIButton) {
        handleRegister()
    }
    
    
    //Olek/Sara method is used for email validation
    var emailErrorMessage  = String()
    
    @discardableResult
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: emailTextField.text!)
        
        if(emailTextField.text == ""){
            errorsArray.append("Email field is empty!");
            return false
        }
        
        if(emailTest != true){
            errorsArray.append("Incorrect format of an email!");
            return false
        }
        return true
    }//end of isValidEmail method
    
    
    //Method is used for password's fields match validation
    @discardableResult
    func isPaswordsMatch() -> Bool {
        if(passwordTextField.text != repasswordTextField.text){
            //password fields are not match
            errorsArray.append("Passwords are not match!");
            return false
        }
        return true
    }//end of isPaswordsMatch method
    
    
    //Method is used for password's fields empty validation
    @discardableResult
    func isPasswordsEmpty() -> Bool {
        if (passwordTextField.text == "" && repasswordTextField.text == ""){
            //password fields are empty
            errorsArray.append("Password fields are empty!");
            return false
        }
        return true
    }//end of isPasswordsEmpty method
    
    
    func handleRegister() {
        
        errorsArray = [String]()//empty our errorsArray before checks will performe
        
        isValidEmail()
        isPasswordsEmpty()
        isPaswordsMatch()
        
        if(errorsArray.isEmpty){
            createUserInDataBase()//create user and send it to databse
        }
            
        else{
            errorMessage = errorsArray.joined(separator: "\n")//concatinate strings from an array and format an error message from them
            generalAlert()
        }
        //Olek/Sara end of else clause where user is adding if password and email matches requirements
        
    }//end of handleRegister method
    
    
    func createUserInDataBase()
    {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text else{
                print ("Form filled inappropriately")
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error ) in
            
            if error != nil {
                self.emailExistsAlert()//calls an alert box if email is already exists in a databse Olek
                //print(error as Any)
                return
            }
            else {
                print("User Created")
            }
            
            //Push entered information to Firebase Database
            //Guard statment gives us access to UID similar to email, Username and Password above.
            guard let userID = Auth.auth().currentUser?.uid else { return }
            
            Firestore.firestore().collection("user").document(userID).setData([
                "email" : email,
                "firstName" : firstName,
                "lastName" : lastName,
                "password": password,
                "isAdmin": false,
                "dateCreated": FieldValue.serverTimestamp()
                
                ], completion: { (error) in
                    if let error = error {
                        print(error as Any)
                    } else {
                        print ("User Data saved to Firebase Database!")
                        self.goToHomePage()// call goToHomePage method
                    }
            })
            
        })
    }
    
    
    func goToHomePage() {
        let signUpStoryBoard = UIStoryboard(name: "SignUp", bundle: nil)
        let myAccountViewController = signUpStoryBoard.instantiateViewController(withIdentifier: "myAccount") as! MyAccountViewController
        self.navigationController?.setViewControllers([myAccountViewController], animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
