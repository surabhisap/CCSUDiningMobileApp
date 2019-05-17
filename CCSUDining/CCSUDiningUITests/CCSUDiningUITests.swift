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
    
    func testSignUp() {
        
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
        emailTextField.typeText("sura@my.ccsu.edu")
        
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
    
    func testMenuFavorite() {
        // Use recording to get started writing UI tests.
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Hilltop Cafe"]/*[[".cells.staticTexts[\"Hilltop Cafe\"]",".staticTexts[\"Hilltop Cafe\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let dicedSmokedHamRedPotatoesCabbageChickenBrothCeleryGarlicAndFreshThymeStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Diced smoked ham, red potatoes, cabbage, chicken broth, celery, garlic and fresh thyme"]/*[[".cells.staticTexts[\"Diced smoked ham, red potatoes, cabbage, chicken broth, celery, garlic and fresh thyme\"]",".staticTexts[\"Diced smoked ham, red potatoes, cabbage, chicken broth, celery, garlic and fresh thyme\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        dicedSmokedHamRedPotatoesCabbageChickenBrothCeleryGarlicAndFreshThymeStaticText.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Sodium"]/*[[".cells.staticTexts[\"Sodium\"]",".staticTexts[\"Sodium\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(2)
        app.alerts["Smoked Ham, Cabbage & Potato Soup added to favroite"].buttons["Ok"].tap()
        app.tabBars.buttons["My Account"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Favorites"]/*[[".cells.staticTexts[\"Favorites\"]",".staticTexts[\"Favorites\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        dicedSmokedHamRedPotatoesCabbageChickenBrothCeleryGarlicAndFreshThymeStaticText.tap()
        app.alerts["Smoked Ham, Cabbage & Potato Soup is available today in Hilltop Cafe"].buttons["Ok"].tap()
        sleep(2)
    }
    
    func testViewReviews() {
        // Use recording to get started writing UI tests.
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Add Reviews(10)"]/*[[".cells.buttons[\"Add Reviews(10)\"]",".buttons[\"Add Reviews(10)\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let addReviewsForHilltopCafeNavigationBar = app.navigationBars["Add Reviews for Hilltop Cafe"]
        addReviewsForHilltopCafeNavigationBar.buttons["customerReviews"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"super cool")/*[[".cells.containing(.staticText, identifier:\"I like this app\")",".cells.containing(.staticText, identifier:\"super cool\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements["Rating"].swipeUp()
        tablesQuery.children(matching: .cell).element(boundBy: 2).otherElements["Rating"].swipeDown()
        app.navigationBars["CCSUDining.ViewDinerReviews"].buttons["Add Reviews for Hilltop Cafe"].tap()
        addReviewsForHilltopCafeNavigationBar.buttons["Diners"].tap()
        
    }
    
    func testAppFeedback() {
        // Use recording to get started writing UI tests.
        
        let app = XCUIApplication()
        app.tabBars.buttons["My Account"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["App Feedback"]/*[[".cells.staticTexts[\"App Feedback\"]",".staticTexts[\"App Feedback\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let feedbackTitleTextField = app.textFields["Feedback Title"]
        feedbackTitleTextField.tap()
        feedbackTitleTextField.typeText("Thanks guys for this awesome app")
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let feedbackCommentTextView = element.children(matching: .textView).element
        feedbackCommentTextView.tap()
        feedbackCommentTextView.typeText("I really like the filter feature of this app, now I can easily sort, search the food I want.")
        sleep(2)
        element.tap()
        app.buttons["Submit"].tap()
        app.alerts["Thank you"].buttons["OK"].tap()
        
    }

}
