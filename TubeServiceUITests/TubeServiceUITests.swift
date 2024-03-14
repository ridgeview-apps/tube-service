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
    
    private var iPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    private var iPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }
    
    var screenshotNumber = 0

    @MainActor
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        
        app = XCUIApplication()
        app.launchArguments = ["UITests"]
        setupSnapshot(app)
        app.launch()
        
        // Handle location permisssions alert
        addUIInterruptionMonitor(withDescription: "Allow \"Tube Service\" to use your location?") { (alert) -> Bool in
            let button = alert.buttons["Allow While Using App"]
            if button.exists {
                button.tap()
                return true
            }

            return false
        }
    }
    
    @MainActor
    func testGenerateAppScreenshots() throws {
                       
        XCUIDevice.shared.orientation = iPad ? .landscapeLeft : .portrait

        captureStatusTab()
        captureJourneyPlannerTab()
        captureArrivalsTab()
        captureNearbyStationsTab()
        captureMapsTab()
    }
    
    @MainActor
    private func captureStatusTab() {
        app.buttons["Status"].tap()
        
        if iPhone {
            captureScreenshot("ServiceStatuses-Today")
        }
        
        // Status - today
        _ = app.buttons["circle"].waitForExistence(timeout: 10)
        app.buttons["circle"].tapUnhittable()
        captureScreenshot("ServiceStatusDetail-Today")
        
        if iPhone {
            app.navigationBars.buttons.element(boundBy: 0).tap() // Back
        }
        
        // Status - weekend
        
        app.buttons["acc.id.filter.option.thisWeekend"].tap()
        captureScreenshot("ServiceStatuses-Weekend")
    }
    
    @MainActor
    private func captureJourneyPlannerTab() {
        app.buttons["Journey planner"].tap()
        
        app.buttons["Departure location"].tap()
        app.textFields.firstMatch.typeText("King's Cross & St Pancras International")
        
        if app.buttons["King's Cross & St Pancras International"].waitForExistence(timeout: 5) {
            app.buttons["King's Cross & St Pancras International"].tapUnhittable()
        }
        
        app.buttons["Arrival location"].tap()
        app.textFields.firstMatch.typeText("Waterloo")
        
        if app.buttons["Waterloo"].waitForExistence(timeout: 5) {
            app.buttons["Waterloo"].tapUnhittable()
        }
        
        captureScreenshot("JourneyPlannerForm")
        
        app.buttons["Show journeys"].tap()
        
        if app.buttons["journey.start.time.info"].firstMatch.waitForExistence(timeout: 5) {
            app.buttons["journey.start.time.info"].firstMatch.tap()
        } else {
            XCTFail()
            return
        }
        
        if app.buttons["3 stops"].firstMatch.waitForExistence(timeout: 5) {
            app.buttons["3 stops"].firstMatch.tap()
        }
        
        captureScreenshot("JourneyPlannerResults")
    }
    
    @MainActor
    private func captureArrivalsTab() {
        app.buttons["Live arrivals"].tap()
        
        if iPhone {
            captureScreenshot("LiveArrivalsPicker")
        }
        
        app.buttons["910GABWDXR-elizabeth"].tapUnhittable() // Abbey Wood
        
        captureScreenshot("LiveArrivalsBoard1")
        
        if iPhone {
            app.navigationBars.buttons.element(boundBy: 0).tap() // Back
        }
    }
    
    @MainActor
    private func captureNearbyStationsTab() {
        app.buttons["Nearby"].tap()
        
        if iPhone {
            captureScreenshot("NearbyStations-List")
        }
        
        if app.buttons["King's Cross & St Pancras International, 200 yd"].waitForExistence(timeout: 20) {
            app.buttons["King's Cross & St Pancras International, 200 yd"].tapUnhittable()
        } else {
            XCTFail()
            return
        }
        
        captureScreenshot("NearbyStations-Detail")
    }
    
    @MainActor
    private func captureMapsTab() {
        app.buttons["Maps"].tap()
        
        captureScreenshot("Maps")
    }
    
    @MainActor
    private func captureScreenshot(_ name: String) {
        screenshotNumber += 1
        let numPrefix = String(format: "%02d", screenshotNumber)
        snapshot("\(numPrefix)-\(name)")
    }
}

extension XCUIElement {
    func tapUnhittable() {
        XCTContext.runActivity(named: "Tap \(self) by coordinate") { _ in
            coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        }
    }
}
