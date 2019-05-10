//
//  FeedbackViewController.swift
//  CCSUDining
//
//  Created by Surabhi on 5/9/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit

class FeedbackViewController: UIViewController {
    
    @IBOutlet weak var feebbackCommentTextView: InspectableUITextView!
    @IBOutlet weak var feedbackTitleTextField: InspectableUITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Feedback"
    }
    @IBAction func submitFeedback(_ sender: Any) {
        
        view.endEditing(true)
        if feedbackTitleTextField.text.count > 0 && feebbackCommentTextView.text.count > 0 {
            APIManager.shared.submitAppFeedback(title: feedbackTitleTextField.text, comment: feebbackCommentTextView.text)
            Alert.shared.showAlert(title: "Thank you", message: "Feedback submitted", on: self)
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        } else {
             Alert.shared.showAlert(title: "Please complete your feedback", message: nil, on: self)
        }
        
    }
}

extension FeedbackViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension FeedbackViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
