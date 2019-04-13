//
//  ChangeNameVC.swift
//  CCSUDining
//
//  Created by Tommy on 4/12/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import UIKit
import Firebase

class ChangeNameVC: UIViewController {

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appUser = db.collection(USERS_REF).document(uid)
        appUser.getDocument { (document, error) in
            if let document = document, document.exists {
                let firstName = document.data()?[FIRST_NAME]
                let lastName = document.data()?[LAST_NAME]
                self.txtFirstName.text = firstName as? String
                self.txtLastName.text = lastName as? String

            } // Do any additional setup after loading the view.
        }
    }
    
    @IBAction func btnSave(_ sender: Any) {
        db.collection(USERS_REF).document(uid).setData([
            FIRST_NAME : txtFirstName.text ?? "",
            LAST_NAME : txtLastName.text ?? ""
            ], completion: { (error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                } else {               self.navigationController?.popViewController(animated: true)
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
