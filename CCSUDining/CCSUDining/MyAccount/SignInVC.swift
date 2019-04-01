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
    @IBOutlet weak var btnSignIn: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func btnSignInTapped(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            if error != nil {
                print(error!)
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
