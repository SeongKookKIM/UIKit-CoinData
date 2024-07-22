//
//  CoinAppUITests.swift
//  CoinAppUITests
//
//  Created by SeongKook on 7/22/24.
//

import XCTest
@testable import CoinApp

final class CoinAppUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        // 앱 실행 시 TokenManager 초기화를 위한 launch argument 추가
        app.launchArguments.append("--uitesting")

        app.launch()
    }

    // 로그인 테스트
    func testLoginFlow() throws {
        
        // User 탭 선택
        let loginButton = app.buttons["User"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5))
        loginButton.tap()

        // 사용자 이름과 비밀번호를 입력합니다.
        let usernameTextField = app.textFields["usernameTextField"]
        let passwordSecureTextField = app.secureTextFields["passwordTextField"]

        usernameTextField.tap()
        usernameTextField.typeText("ksk8646")

        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("Tlqkfdk2@")

        // 로그인 버튼을 탭합니다.
        let signInButton = app.buttons["loginButton"]
        signInButton.tap()
        
        // 로그인 성공 후 나타나는 알림을 기다립니다.
        let loginAlert = app.alerts["loginAlert"]
        XCTAssertTrue(loginAlert.waitForExistence(timeout: 5))

        // 확인 버튼을 탭합니다.
        loginAlert.buttons["확인"].tap()

        // 로그인 후 CoinListView로 이동했는지 확인합니다.
        let coinListView = app.otherElements["CoinListView"]
        let exists = coinListView.waitForExistence(timeout: 10)
        
        if !exists {
            // 실패 시 더 자세한 정보를 얻기 위해 현재 화면의 요소들을 출력합니다.
            print("Current screen elements:")
            print(app.debugDescription)
        }

        XCTAssertTrue(exists, "Failed to navigate to CoinListView after login")
    }
}
