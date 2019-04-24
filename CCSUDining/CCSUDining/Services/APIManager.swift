//
//  APIManager.swift
//  CCSUDining
//  Created by Surabhi Agnihotri on 2/25/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import CodableFirebase
import FirebaseFirestore

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
                    if let formalName = menuModel.formalName, formalName.count > 0, let description = menuModel.description, description.count > 0 {
                        menuModels.append(menuModel)
                    }
                }

                //Group the menu models by Dining hall names eg. [["Memorial Hall": [menuModel1, menuModel2, ...,menuModeln], ["Devil's den": [menuModel5, menuModel6, ...,menuModelm] ]]
                let groupedMenuModels = menuModels.group(by: { $0.dining_hall ?? "" })
                completionHandler(groupedMenuModels)
            }
        }
    }
    
    func fetchDinerRatings(completionHandler: @escaping (([String: String]) -> Void)) {
        
        var dinerRatingDictionary = [String: String]()
        db.collection("DiningHalls").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let dinerName = document.documentID
                    var totalRating = 0
                    if let reviewsArray = document.data()["reviews"] as? [[String: String]] {
                        for review in reviewsArray  {
                            if let rating = Int(review["rating"] ?? "0") {
                                totalRating += rating
                            }
                        }
                        if reviewsArray.count > 0 {
                            totalRating = totalRating / reviewsArray.count
                        }
                    }
                    dinerRatingDictionary[dinerName] = "\(totalRating)"
                }
                completionHandler(dinerRatingDictionary)
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
