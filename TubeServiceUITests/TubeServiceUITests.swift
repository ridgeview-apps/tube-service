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

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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

        // Status tab
        app.buttons["Status"].tap()

        if iPhone {
            captureScreenshot("ServiceStatuses")
        }

        // Status detail
        app.buttons["northern"].tap()
        captureScreenshot("ServiceStatusDetail")

        if iPhone {
            app.navigationBars.buttons.element(boundBy: 0).tap() // Back
        }
        
        // Arrivals List
        app.buttons["Live arrivals"].tap()
        
        if iPhone {
            captureScreenshot("LiveArrivalsPicker")
        }
        
        app.buttons["940GZZLUAGL-940GZZLUAGL-northern"].tap() // Angel
        
        captureScreenshot("LiveArrivalsBoard1")
        
        if iPhone {
            app.navigationBars.buttons.element(boundBy: 0).tap() // Back
        }
        
        if iPad {
            app.buttons["940GZZLUALP-940GZZLUALP-piccadilly"].swipeUp()
        }
        
        app.buttons["940GZZLUBBN-940GZZLUBBN-circle,hammersmith-city,metropolitan"].tap() // Barbican
                
        captureScreenshot("LiveArrivalsBoard2")
    }
}
