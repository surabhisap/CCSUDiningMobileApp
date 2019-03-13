//
//  APIManager.swift
//  CCSUDining
//  Created by Surabhi Agnihotri on 2/25/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import CodableFirebase
import FirebaseFirestore

class APIManager {
    
    static let shared = APIManager()
    
    func fetchCollection(collectionName: String, completionHandler: @escaping (([String: [MenuModel]]) -> Void)) {
        
        Firestore.firestore().collection(collectionName).getDocuments()  { documentSnapShot, error in
            var menuModels = [MenuModel]()
            if let documents = documentSnapShot?.documents {
                for document in documents {
                    print("\(document.documentID) => \(document.data())")
                    let menuModel = try! FirestoreDecoder().decode(MenuModel.self, from: document.data())
                    if let formalName = menuModel.formalName, formalName.count > 0, let description = menuModel.description, description.count > 0 {
                        menuModels.append(menuModel)
                    }
                }

                let groupedMenuModels = menuModels.group(by: { $0.dining_hall ?? "" })
                completionHandler(groupedMenuModels)
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
