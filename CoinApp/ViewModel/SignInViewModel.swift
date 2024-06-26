//
//  AuthViewModel.swift
//  CoinApp
//
//  Created by SeongKook on 6/26/24.
//

import Foundation

class SignInViewModel {
    
    private let autherService = AuthService()
    
    // 유효성 검사
    var nickname: String = "" {
        didSet { validateNickname() }
    }
    
    var id: String = "" {
        didSet { validateID() }
    }
    
    var password: String = "" {
        didSet { validatePassword() }
    }
    
    var passwordCheck: String = "" {
        didSet { validatePasswordCheck() }
    }
    
    // 에러 메세지
    var nicknameErrorMessage: String = ""
    var idErrorMessage: String = ""
    var passwordErrorMessage: String = ""
    var passwordCheckErrorMessage: String = ""
    
    var isFormValid: Bool = false
    
    // 유효성 검사 메서드
    private func validateNickname() {
        if nickname.count >= 2 {
            nicknameErrorMessage = ""
        } else {
            nicknameErrorMessage = "닉네임은 2자 이상이어야 합니다."
        }
        validateForm()
    }
    
    // 정규식 패턴 확인
    private func validateID() {
        let idRegex = "^(?=.*[a-zA-Z])(?=.*\\d)[a-zA-Z0-9]{6,}$"
        if NSPredicate(format: "SELF MATCHES %@", idRegex).evaluate(with: id) {
            idErrorMessage = ""
        } else {
            idErrorMessage = "아이디는 영문 숫자 조합 6자 이상이어야 합니다."
        }
        validateForm()
    }
    
    private func validatePassword() {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+=-]).{8,}$"
        if NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password) {
            passwordErrorMessage = ""
        } else {
            passwordErrorMessage = "비밀번호는 소문자, 대문자, 숫자, 특수기호 포함 8자 이상이어야 합니다."
        }
        validateForm()
    }
    
    private func validatePasswordCheck() {
        if password == passwordCheck {
            passwordCheckErrorMessage = ""
        } else {
            passwordCheckErrorMessage = "비밀번호가 일치하지 않습니다."
        }
        validateForm()
    }
    
    // 유효성 통과시 버튼 활성화 함수
    private func validateForm() {
        isFormValid = nicknameErrorMessage.isEmpty &&
                      idErrorMessage.isEmpty &&
                      passwordErrorMessage.isEmpty &&
                      passwordCheckErrorMessage.isEmpty &&
                      !nickname.isEmpty &&
                      !id.isEmpty &&
                      !password.isEmpty &&
                      !passwordCheck.isEmpty
    }
    
    // 서버에 회원가입 요청
    func signIn() async throws -> SingInResultModel {
        let userSignInfo = UserSignIn(nickName: nickname, id: id, password: password)
        return try await autherService.signIn(userSignInfo: userSignInfo)
    }
}
