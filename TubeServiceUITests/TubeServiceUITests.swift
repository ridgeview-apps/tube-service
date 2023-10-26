//
//  TubeServiceUITests.swift
//  TubeServiceUITests
//
//  Created by Shilan Patel on 20/11/2020.
//  Copyright © 2020 Shilan Patel. All rights reserved.
//

import XCTest

class TubeServiceUITests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["UITests"]
        setupSnapshot(app)
        app.launch()
    }
    
    func testGenerateAppScreenshots() throws {
                       
        var screenshotNumber = 0
        func captureScreenshot(_ name: String) {
            screenshotNumber += 1
            let numPrefix = String(format: "%02d", screenshotNumber)
            snapshot("\(numPrefix)-\(name)")
        }
        
        let iPhone = UIDevice.current.userInterfaceIdiom == .phone
        let iPad = UIDevice.current.userInterfaceIdiom == .pad
        
        XCUIDevice.shared.orientation = iPad ? .landscapeLeft : .portrait

        app.buttons["Status"].tap()

        // Status - Today
        
        if iPhone {
            captureScreenshot("ServiceStatuses-Today")
        }

        // Status detail - Today
        
        app.buttons["circle"].tapUnhittable()
        captureScreenshot("ServiceStatusDetail-Today")
        
        if iPhone {
            app.navigationBars.buttons.element(boundBy: 0).tap() // Back
        }
        
        // Status - Weekend
        
        app.buttons["acc.id.filter.option.thisWeekend"].tap()
        captureScreenshot("ServiceStatuses-Weekend")
        
        
        // Arrivals List
        app.buttons["Live arrivals"].tap()
        
        if iPhone {
            captureScreenshot("LiveArrivalsPicker")
        }
        
        app.buttons["910GABWDXR-elizabeth"].tapUnhittable() // Abbey Wood
        
        captureScreenshot("LiveArrivalsBoard1")
        
        if iPhone {
            app.navigationBars.buttons.element(boundBy: 0).tap() // Back
        }
        
        app.buttons["Maps"].tap()
        
        captureScreenshot("Maps")
    }
}

extension XCUIElement {
    func tapUnhittable() {
        XCTContext.runActivity(named: "Tap \(self) by coordinate") { _ in
            coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        }
    }
}
