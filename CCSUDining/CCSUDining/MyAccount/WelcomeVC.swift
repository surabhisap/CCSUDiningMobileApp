//
//  WelcomeVC.swift
//  CCSUDining
//
//  Created by Tommy on 3/28/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import UIKit
import Firebase

class WelcomeVC: UIViewController {
    private var handle: AuthStateDidChangeListenerHandle?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "account")
                self.present(loginVC, animated: true, completion: nil)
            }
        })
    }


}
