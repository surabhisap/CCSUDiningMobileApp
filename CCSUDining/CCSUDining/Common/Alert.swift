//
//  Alert.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 4/16/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    private init() {}
    
    static let shared = Alert()
    
    func showAlert(title: String?, message: String?, on viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String?, message: String?, on viewController: UIViewController, alertActions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        for alertAction in alertActions {
            alert.addAction(alertAction)
        }
        viewController.present(alert, animated: true, completion: nil)
    }
}
