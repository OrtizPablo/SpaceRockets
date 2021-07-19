//
//  SpaceXRocketsUITests.swift
//  SpaceXRocketsUITests
//
//  Created by Pablo Ortiz Rodríguez on 31/5/21.
//

import XCTest

class SpaceXRocketsUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    func testHappyFlow() {
        XCTAssertTrue(app.navigationBars.staticTexts["Rockets"].exists)
        let table = app.tables["rocketListTableView"]
        XCTAssertTrue(table.exists)
        
        let cell1 = table.cells["rocketListViewCell0"]
        testRocketListCell(cell: cell1, title: "Falcon 1", subtitle: "Mar 24, 2006", status: "Inactive")
        let cell2 = table.cells["rocketListViewCell1"]
        testRocketListCell(cell: cell2, title: "Falcon 9", subtitle: "Jun 4, 2010", status: "Active")
        let cell3 = table.cells["rocketListViewCell2"]
        testRocketListCell(cell: cell3, title: "Falcon Heavy", subtitle: "Feb 6, 2018", status: "Active")
        let cell4 = table.cells["rocketListViewCell3"]
        testRocketListCell(cell: cell4, title: "Starship", subtitle: "Dec 1, 2021", status: "Inactive")
        
        cell1.tap()
        testRocketDetailsElements(navTitle: "Falcon 1",
                                  descriptionText: "The Falcon 1 was an expendable launch system privately developed and manufactured by SpaceX during 2006-2009. On 28 September 2008, Falcon 1 became the first privately-developed liquid-fuel launch vehicle to go into orbit around the Earth.",
                                  firstFlight: "Mar 24, 2006",
                                  costPerLaunch: "£6700000",
                                  successRate: "40%",
                                  company: "SpaceX",
                                  country: "Republic of the Marshall Islands")
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        cell2.tap()
        testRocketDetailsElements(navTitle: "Falcon 9",
                                  descriptionText: "Falcon 9 is a two-stage rocket designed and manufactured by SpaceX for the reliable and safe transport of satellites and the Dragon spacecraft into orbit.",
                                  firstFlight: "Jun 4, 2010",
                                  costPerLaunch: "£50000000",
                                  successRate: "98%",
                                  company: "SpaceX",
                                  country: "United States")
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    private func testRocketListCell(cell: XCUIElement, title: String, subtitle: String, status: String) {
        XCTAssertTrue(cell.exists)
        XCTAssertTrue(cell.staticTexts[title].exists)
        XCTAssertTrue(cell.staticTexts[subtitle].exists)
        XCTAssertTrue(cell.staticTexts[status].exists)
    }
    
    private func testRocketDetailsElements(navTitle: String,
                                           descriptionText: String,
                                           firstFlight: String,
                                           costPerLaunch: String,
                                           successRate: String,
                                           company: String,
                                           country: String) {
        XCTAssertTrue(app.navigationBars.staticTexts[navTitle].exists)
        XCTAssertTrue(app.staticTexts["Description"].exists)
        let predicate = NSPredicate(format: "label LIKE %@", descriptionText)
        XCTAssertTrue(app.staticTexts.element(matching: predicate).exists)
        XCTAssertTrue(app.staticTexts["First Flight"].exists)
        XCTAssertTrue(app.staticTexts[firstFlight].exists)
        XCTAssertTrue(app.staticTexts["Cost Per Launch"].exists)
        XCTAssertTrue(app.staticTexts[costPerLaunch].exists)
        XCTAssertTrue(app.staticTexts["Success Rate"].exists)
        XCTAssertTrue(app.staticTexts[successRate].exists)
        XCTAssertTrue(app.staticTexts["Company"].exists)
        XCTAssertTrue(app.staticTexts[company].exists)
        XCTAssertTrue(app.staticTexts["Country"].exists)
        XCTAssertTrue(app.staticTexts[country].exists)
    }
}
