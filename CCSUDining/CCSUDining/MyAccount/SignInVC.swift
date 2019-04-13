//
//  LogInPopUpVC.swift
//  CCSUDining
//
//  Created by Tom Dugan on 3/16/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    //outlets
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblError: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignIn.layer.cornerRadius = 10
        btnCancel.layer.cornerRadius = 10

    }
    @IBAction func btnSignInTapped(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            if error != nil {
                self.lblError.text = error?.localizedDescription
            }
            else {
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    


}
