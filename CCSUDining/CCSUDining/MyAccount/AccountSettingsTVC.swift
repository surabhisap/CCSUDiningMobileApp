	//
//  AccountSettingsTVC.swift
//  CCSUDining
//
//  Created by Tommy on 3/24/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import UIKit
import Firebase
class AccountSettingsTVC: UITableViewController {

    
    @IBOutlet weak var cellName: UITableViewCell!
    @IBOutlet weak var cellEmail: UITableViewCell!
    @IBOutlet weak var cellLogout: UITableViewCell!
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        cellName.textLabel?.numberOfLines = 0
        cellName.textLabel?.lineBreakMode = .byWordWrapping
        cellEmail.textLabel?.numberOfLines = 0
        cellEmail.textLabel?.lineBreakMode = .byWordWrapping
        cellLogout.textLabel?.text = "Log Out"
        
        

        }
       // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

    override func viewDidAppear(_ animated: Bool) {
        let appUser = db.collection(USERS_REF).document(uid)
        appUser.getDocument { (document, error) in
            if let document = document, document.exists {
                let firstName = document.data()?[FIRST_NAME]
                let lastName = document.data()?[LAST_NAME]
                self.cellName.textLabel?.text = "Name \n \(firstName ?? "") \(lastName ?? "")"
            }
                
        }
    }

    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 2 {
            do {
                try Auth.auth().signOut()
            }
            catch let signoutError as NSError {
                debugPrint("error: \(signoutError) " )
            }
        }
    }
}
