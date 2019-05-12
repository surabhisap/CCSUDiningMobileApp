//
//  APIManager.swift
//  CCSUDining
//  Created by Surabhi Agnihotri on 2/25/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import CodableFirebase
import FirebaseFirestore
import Firebase

class APIManager {
    // created shared instance
    static let shared = APIManager()
    private var db: Firestore = Firestore.firestore()

    // fetchCollection fetches the data from fireStore
    func fetchCollection(collectionName: String, completionHandler: @escaping (([String: [MenuModel]]) -> Void)) {
        // Get all documents for collectionName(date) collection
        db.collection(collectionName).getDocuments()  { documentSnapShot, error in
            var menuModels = [MenuModel]()
            if let documents = documentSnapShot?.documents {
                for document in documents {
                    //Decode the data and populate MenuModel
                    let menuModel = try! FirestoreDecoder().decode(MenuModel.self, from: document.data())
                    if let formalName = menuModel.formalName, formalName.count > 0 {
                        menuModels.append(menuModel)
                    }
                }

                UserPreferences.shared.savedAllMenuModels = menuModels
                //Group the menu models by Dining hall names eg. [["Memorial Hall": [menuModel1, menuModel2, ...,menuModeln], ["Devil's den": [menuModel5, menuModel6, ...,menuModelm] ]]
                let groupedMenuModels = menuModels.group(by: { $0.dining_hall ?? "" })
                completionHandler(groupedMenuModels)
            }
        }
    }
    
    func fetchDinerReviews(completionHandler: @escaping (([String: ReviewsModel]) -> Void)) {
        
        var dinerReviewsDictionary = [String: ReviewsModel]()
        db.collection("DiningHalls").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let dinerModel = try! FirestoreDecoder().decode(ReviewsModel.self, from: document.data())
                    let dinerName = document.documentID
                    dinerReviewsDictionary[dinerName] = dinerModel
                }
                completionHandler(dinerReviewsDictionary)
            }
        }
    }
    
    func fetchDummyDate(completionHandler: @escaping ((Any?) -> Void)) {
        
        db.collection("StaticData").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let snapshot = snapshot else {
                    return completionHandler("")
                }
                completionHandler(snapshot.documents.first?.data().values.first)
           }
        }
    }
    
    func fetchCurrentUser(completionHandler: @escaping ((UserModel?) -> Void)) {
        
        // Get Current userId
         guard let userID = Auth.auth().currentUser?.uid else { return completionHandler(nil) }
        
        // Get document
        db.collection("user").document(userID).getDocument { document, error in
            if let document = document, let documentData = document.data() {
                let model = try? FirestoreDecoder().decode(UserModel.self, from: documentData)
               completionHandler(model)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func deleteDocument(_ menuModel: MenuModel, completionHandler: @escaping ((Bool?) -> Void)) {
        
        guard let date = menuModel.startTime, let menuItemId = menuModel.menuItemId else {
            completionHandler(false)
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date.dateValue())
        
        db.collection(dateString).document("\(menuItemId)").updateData([
            "capital": FieldValue.delete(),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                completionHandler(false)
            } else {
                print("Document successfully updated")
                completionHandler(true)
            }
        }
    }
    
    // Add a new document with a generated id.
    func submitAppFeedback(title: String, comment: String) {
        db.collection("feedback").addDocument(data: [
            "title": title,
            "comment": comment
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
        }
    }
    
    func updateUser(_ userDictionary: [String: String], completionHandler: @escaping ((Bool) -> Void)) {
       
        // Get Current userId
        guard let userID = Auth.auth().currentUser?.uid else { return completionHandler(false) }
        db.collection("user").document(userID).updateData( userDictionary, completion: { (error) in
                if let error = error {
                    completionHandler(false)
                    print(error as Any)
                } else {
                    completionHandler(true)
                    print ("User Data saved to Firebase Database!")
                }
        })
    }
    
}

extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        return Dictionary.init(grouping: self, by: key)
    }
}

extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}
