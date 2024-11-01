//
//  WeatherStackAppUITests.swift
//  WeatherStackAppUITests
//
//  Created by PS on 30/10/24.
//

import XCTest
@testable import WeatherStackApp

final class WeatherStackAppUITests: XCTestCase {

	let app = XCUIApplication()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	/**
	 Executes the test for given scenario, when the data is successfully loaded.
	 */
	func test_HomeScreen_UIElements_Success() throws {
		app.launchArguments = ["MOCK_VIEWMODEL_DATA_LOADED"]
		app.launch()
		let existPredicate = NSPredicate(format: "exists = 1")
		let weatherInfoElement = app.staticTexts["WeatherInfoView"]
		let weatherInfoShownExpectation = expectation(for: existPredicate, evaluatedWith: weatherInfoElement)
		wait(for: [weatherInfoShownExpectation], timeout: 15, enforceOrder: false)
	}
	
	/**
	 Executes the test for given scenario, when the data is  not successfully loaded and alert is shown to retry.
	 */
	func test_HomeScreen_UIElements_Failure() throws {
		app.launchArguments = ["MOCK_VIEWMODEL_DATA_LOADING_FAILURE"]
		app.launch()
		sleep(2)
		let retryButton = XCUIApplication().alerts["Error"].scrollViews.otherElements.buttons["Retry"]
		XCTAssert(retryButton.exists)
		retryButton.tap()
	}
	
	func test_AboutScreen() throws {
		app.launchArguments = ["MOCK_VIEWMODEL_DATA_LOADED"]
		app.launch()
		let tabBar = XCUIApplication().tabBars["Tab Bar"]
		let infoButton = tabBar.buttons["Info"]
		infoButton.tap()
		XCTAssert(app.staticTexts["AppDetailsText"].exists)
		XCTAssert(app.staticTexts["AppArchitectureText"].exists)
		
	}
}
