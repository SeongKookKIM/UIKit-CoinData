//
//  CoinAppUITestsLaunchTests.swift
//  CoinAppUITests
//
//  Created by SeongKook on 7/22/24.
//

import XCTest

final class CoinAppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
        // 잠시 지연 추가
        sleep(2)

        // Splash 화면의 이미지 뷰가 제대로 표시되는지 확인합니다.
        let splashImageView = app.otherElements["splashImageView"]
        XCTAssertTrue(splashImageView.waitForExistence(timeout: 5), "Splash screen image view does not exist.")

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
