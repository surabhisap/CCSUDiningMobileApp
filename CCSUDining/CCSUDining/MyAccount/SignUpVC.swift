//
//  LoginVC.swift
//  CCSUDining
//
//  Created by Tom Dugan on 3/16/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    //Outlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignUp.layer.cornerRadius = 10
        btnCancel.layer.cornerRadius = 10
        
    }

    @IBAction func btnSignUpTapped(_ sender: Any) {
        guard let email = txtEmail.text,
            let pwd = txtPassword.text else { return }
        Auth.auth().createUser(withEmail: email, password: pwd) { (user, error) in
            
            if let error = error {
                debugPrint("Error Creating User: \(error.localizedDescription)")
            }
            
            //let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            guard let userID = Auth.auth().currentUser?.uid else {return}
            
            Firestore.firestore().collection(USERS_REF).document(userID).setData([
                USERNAME : email,
                DATE_CREATED: FieldValue.serverTimestamp()
                
                ], completion: { (error) in
                    if let error = error {
                        debugPrint(error.localizedDescription)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
            })
        }
    }
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
}
