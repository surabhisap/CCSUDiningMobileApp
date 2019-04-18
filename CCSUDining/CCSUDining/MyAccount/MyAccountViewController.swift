//
//  LoginViewController.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 4/17/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MyAccountViewController: UIViewController {
    
    private var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUserTitle()
        
        let barButton = UIBarButtonItem(image: UIImage(named: "settingsIcon"), style: .plain, target: self, action: #selector(showSettigs))
        self.navigationItem.rightBarButtonItem  = barButton
    }
    
    private func setUserTitle() {
        
        let db = Firestore.firestore()
        handle = Auth.auth().addStateDidChangeListener({ [weak self] (auth, user) in
            if user != nil {
                let appUser = db.collection("user").document(Auth.auth().currentUser!.uid)
                appUser.getDocument { (document, error) in
                    if let document = document, document.exists {
                        self?.navigationItem.title = "Hello, \(document.data()?["firstName"] ?? document.data()?["username"] ?? "Hacker")"
                    }
                }
            }
        })
    }
    
    @objc func showSettigs(){
        performSegue(withIdentifier: "settings", sender: nil)
    }
}
