//
//  CCSUDiningTests.swift
//  CCSUDiningTests
//
//  Created by Surabhi Agnihotri on 2/21/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import XCTest
import CodableFirebase
import FirebaseFirestore
import Firebase

@testable import CCSUDining

class CCSUDiningTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCollectionFetch() {
        retrieveData()
    }
    
    private func retrieveData() {
        
        let dataExpectation = expectation(description: "Failed to get data")
        let dinnerViewModel = DinerViewModel()
        
        dinnerViewModel.getMenuForToday { (menuModelArray) in
            
            XCTAssertNotNil(menuModelArray)
            XCTAssertTrue(menuModelArray.count > 0, "Test Suceed")
            XCTAssertNotNil(menuModelArray.first?.value.first?.formalName)
            XCTAssertNotNil(menuModelArray.first?.value.first?.menuItemId)
            dataExpectation.fulfill()
            
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
        
    }
    
    func testDinerReviews() {
        
        let dataExpectation = expectation(description: "Failed to get data")
        APIManager.shared.fetchDinerReviews { dinerReviews in
            for diner in dinerReviews {
                XCTAssertNotNil(diner.value.reviews)
                if let review = diner.value.reviews?.first?.reviewTitle {
                    XCTAssertTrue(review.count > 0)
                }
            }
            dataExpectation.fulfill()
        }
         waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testCurrentUser() {
        
        let dataExpectation = expectation(description: "Failed to get data")
        Auth.auth().signIn(withEmail: "surabhiccsu@my.ccsu.edu", password: "surabhi@ccsu", completion: { (_, _) in
            
            APIManager.shared.fetchCurrentUser { (currentUser) in
                XCTAssertEqual(currentUser?.firstName, "surabhi")
                XCTAssertEqual(currentUser?.lastName, "agnihotri")
                XCTAssertEqual(currentUser?.isAdmin, false)
                XCTAssertEqual(currentUser?.email, "surabhiccsu@my.ccsu.edu")
                dataExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 10.0, handler: nil)
    }
        
    
    
}
