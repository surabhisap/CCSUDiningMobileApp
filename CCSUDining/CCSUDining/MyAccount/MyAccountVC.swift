//
//  MyAccountVC.swift
//  CCSUDining
//
//  Created by Tommy on 3/28/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import UIKit
import Firebase



class MyAccountVC: UIViewController {
    
    @IBOutlet weak var lblGreeting: UILabel!
    private var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let db = Firestore.firestore()
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //let loginVC = storyboard.instantiateViewController(withIdentifier: "welcome")
                //self.present(loginVC, animated: true, completion: nil)
                self.performSegue(withIdentifier: "gotoSignIn", sender: self)
                self.lblGreeting.isHidden = true
            }
            else {
                let appUser = db.collection(USERS_REF).document(Auth.auth().currentUser!.uid)
                appUser.getDocument { (document, error) in
                    if let document = document, document.exists {
                        self.lblGreeting.text = "Hello, \(document.data()?[FIRST_NAME] ?? document.data()?[USERNAME] ?? "Hacker")"
                    }
                }
                
            }
        })
    }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
