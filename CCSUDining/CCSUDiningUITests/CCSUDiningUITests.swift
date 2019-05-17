//
//  CCSUDiningUITests.swift
//  CCSUDiningUITests
//
//  Created by Surabhi Agnihotri on 2/21/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import XCTest

class CCSUDiningUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMealTypeFilter() {
        // Use recording to get started writing UI tests.
        let app = XCUIApplication()
        sleep(5)
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Memorial Hall"]/*[[".cells.staticTexts[\"Memorial Hall\"]",".staticTexts[\"Memorial Hall\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["filter"].tap()
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"Vegetarian").element.tap()
        app.buttons["Apply"].tap()
    }
    
    func testAllergensFilter() {
        // Use recording to get started writing UI tests.
        let app = XCUIApplication()
        sleep(5)
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Memorial Hall"]/*[[".cells.staticTexts[\"Memorial Hall\"]",".staticTexts[\"Memorial Hall\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["filter"].tap()
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"Milk").element.tap()
        app.buttons["Apply"].tap()
        sleep(2)
    }

    
    func testCaloriesFilter() {
        // Use recording to get started writing UI tests.
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Devil's Den"]/*[[".cells.staticTexts[\"Devil's Den\"]",".staticTexts[\"Devil's Den\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["filter"].tap()
        app.collectionViews.sliders["60%"].swipeRight()
        app.buttons["Apply"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["12\" Baja Chicken Sub"]/*[[".cells.staticTexts[\"12\\\" Baja Chicken Sub\"]",".staticTexts[\"12\\\" Baja Chicken Sub\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Cholesterol"]/*[[".cells.staticTexts[\"Cholesterol\"]",".staticTexts[\"Cholesterol\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Fiber"]/*[[".cells.staticTexts[\"Fiber\"]",".staticTexts[\"Fiber\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Calories"]/*[[".cells.staticTexts[\"Calories\"]",".staticTexts[\"Calories\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
       
    }
    
    func testMenuDetail() {
        // Use recording to get started writing UI tests.
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Memorial Hall"]/*[[".cells.staticTexts[\"Memorial Hall\"]",".staticTexts[\"Memorial Hall\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Brown rice, tomatoes, cilantro and toasted pumpkin seeds"]/*[[".cells.staticTexts[\"Brown rice, tomatoes, cilantro and toasted pumpkin seeds\"]",".staticTexts[\"Brown rice, tomatoes, cilantro and toasted pumpkin seeds\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let menuButton = app.navigationBars["Nutritional Information"].buttons["Menu"]
        menuButton.tap()
     
        
    }
    
    func testSignIn() {
        // Use recording to get started writing UI tests.
        
        let app = XCUIApplication()
        app.tabBars.buttons["My Account"].tap()
        
        let signInButton = app.buttons["Sign In"]
        signInButton.tap()
        
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("surabhi.sgo@gmail.com")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("surabhi@sgo")
        
        signInButton.tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .table).element.swipeUp()
        app.tables.buttons["Logout"].tap()
        
    }
    
    func testSignUp() {
        // Use recording to get started writing UI tests.
        
        
        let app = XCUIApplication()
        app.tabBars.buttons["My Account"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.swipeUp()
        
        app.buttons["SIGN UP USING YOUR EMAIL"].tap()
        
        let firstNameTextField = app.textFields["First Name"]
        firstNameTextField.tap()
        firstNameTextField.typeText("surabhi")
        
        let lastNameTextField = app.textFields["Last Name"]
        lastNameTextField.tap()
        lastNameTextField.typeText("agnihotri")
        
        
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("surabhiagnihotri@my.ccsu.eu")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("surabhi@ccsu")
        
        let rePasswordSecureTextField = app.secureTextFields["Re-enter Password"]
        rePasswordSecureTextField.tap()
        rePasswordSecureTextField.typeText("surabhi@ccsu")
        
        element.swipeUp()
        element.tap()
        app.buttons["SIGN UP"].tap()

        sleep(4)
        app.tables.buttons["Logout"].tap()
       
        
    }
    
    
    func testMenuFavorite() {
        // Use recording to get started writing UI tests.
        
    }
    
    func testAddReviews() {
        // Use recording to get started writing UI tests.
        
    }
    
    func testViewReviews() {
        // Use recording to get started writing UI tests.
        
    }
}
