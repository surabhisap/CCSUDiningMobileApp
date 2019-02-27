//
//  APIManager.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 2/25/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import FirebaseFirestore
import CodableFirebase

class APIManager {
    
    static func fetchCollection(collectionName: String) {
        
        Firestore.firestore().collection(collectionName).getDocuments()  { documentSnapShot, error in
            
            if let documents = documentSnapShot?.documents {
                for document in documents {
                    print("\(document.documentID) => \(document.data())")
                    let model = try! FirestoreDecoder().decode(MenuModel.self, from: document.data())
                    print("Model: \(model)")
                }
            }
        }
    }
    
}
