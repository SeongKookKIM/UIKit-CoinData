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
    
    // 회원가입 테스트
    func testA_SignUp() throws {
        let loginButton = app.buttons["User"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5))
        loginButton.tap()
        
        let signUpButton = app.buttons["signUpButton"]
        signUpButton.tap()
        
        let nicknameTF = app.textFields["signUpNickname"]
        let idTF = app.textFields["signUpID"]
        let passwordTF = app.secureTextFields["signUpPW"]
        let passwordCheckedTF = app.secureTextFields["signUpPWCheck"]
        
        nicknameTF.tap()
        nicknameTF.typeText("히히여전사")
        
        idTF.tap()
        idTF.typeText("qwer123")
        
        passwordTF.tap()
        passwordTF.typeText("Qwer123@")
        
        passwordCheckedTF.tap()
        passwordCheckedTF.typeText("Qwer123@")
        
        let submitButton = app.buttons["signUpSubmitBtn"]
        submitButton.tap()
        
        let signUpAlert = app.alerts["signUpAlert"]
        XCTAssertTrue(signUpAlert.waitForExistence(timeout: 5))

        // 확인 버튼을 탭합니다.
        signUpAlert.buttons["확인"].tap()
        
        let loginView = app.otherElements["LoginView"]
        let exists = loginView.waitForExistence(timeout: 5)
        
        if !exists {
            // 실패 시 더 자세한 정보를 얻기 위해 현재 화면의 요소들을 출력합니다.
            print("Current screen elements:")
            print(app.debugDescription)
        }
    }
    
    // 로그인 테스트
    func testB_Login() throws {
        
        // User 탭 선택
        let loginButton = app.buttons["User"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5))
        loginButton.tap()

        // 사용자 이름과 비밀번호를 입력합니다.
        let usernameTextField = app.textFields["usernameTextField"]
        let passwordSecureTextField = app.secureTextFields["passwordTextField"]

        usernameTextField.tap()
        usernameTextField.typeText("qwer123")

        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("Qwer123@")

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
    }
    
    // 회원 정보 수정
    func testC_EditProfile() throws {
        
        let loginButton = app.buttons["User"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5))
        loginButton.tap()
        
        let editProfileButton = app.buttons["editProfileBtn"]
        XCTAssertTrue(editProfileButton.waitForExistence(timeout: 5))
        editProfileButton.tap()
        
        let editNicknameTF = app.textFields["editNickname"]
        let editIDTF = app.textFields["editID"]
        let editPWTF = app.secureTextFields["editPW"]
        let editNewPWTF = app.secureTextFields["editNewPW"]
        let editNewPWCheckTF = app.secureTextFields["editNewPWCheck"]
        
        editNicknameTF.tap()
        clearAndTypeText(textField: editNicknameTF, text: "히히여장군")
        
        editIDTF.tap()
        clearAndTypeText(textField: editIDTF, text: "qwer123")
        
        editPWTF.tap()
        clearAndTypeText(textField: editPWTF, text: "Qwer123@")
        
        editNewPWTF.tap()
        clearAndTypeText(textField: editNewPWTF, text: "Qwer123!@#")
        
        editNewPWCheckTF.tap()
        clearAndTypeText(textField: editNewPWCheckTF, text: "Qwer123!@#")
        
        let editSubmitButton = app.buttons["editSubmitBtn"]
        editSubmitButton.tap()
        
        let editProfileAlert = app.alerts["editProfileAlert"]
        XCTAssertTrue(editProfileAlert.waitForExistence(timeout: 5))

        // 확인 버튼을 탭합니다.
        editProfileAlert.buttons["확인"].tap()
        
        let myPageView = app.otherElements["MyPageView"]
        let exists = myPageView.waitForExistence(timeout: 5)
        
        if !exists {
            print("Current screen elements:")
            print(app.debugDescription)
        }
    }

    // 텍스트 필드의 기존 텍스트를 지우고 새로운 텍스트를 입력하는 함수
    func clearAndTypeText(textField: XCUIElement, text: String) {
        guard let stringValue = textField.value as? String else {
            XCTFail("텍스트 필드의 값이 문자열이 아닙니다.")
            return
        }
        
        let deleteString = stringValue.map { _ in "\u{8}" }.joined() // 기존 텍스트를 삭제할 백스페이스 문자열 생성
        textField.typeText(deleteString)
        textField.typeText(text)
    }
    
    
    // 북마크 테스트
    
    // 북마크 삭제 테스트
    
    // 회원 탈퇴
    
    func testF_withdrawUser() {
        
    }
}
