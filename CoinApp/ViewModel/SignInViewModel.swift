//
//  AuthViewModel.swift
//  CoinApp
//
//  Created by SeongKook on 6/26/24.
//

import Foundation

class SignUpViewModel {
    
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
        if let errorMessage = ValidHelper.validateNickname(nickname) {
            nicknameErrorMessage = errorMessage
        } else {
            nicknameErrorMessage = ""
        }
        validateForm()
    }
    
    // 정규식 패턴 확인
    private func validateID() {
        if let errorMessage = ValidHelper.validateID(id) {
            idErrorMessage = errorMessage
        } else {
            idErrorMessage = ""
        }
        validateForm()
    }
    
    private func validatePassword() {
        if let errorMessage = ValidHelper.validatePassword(password) {
            passwordErrorMessage = errorMessage
        } else {
            passwordErrorMessage = ""
        }
        validateForm()
    }
    
    private func validatePasswordCheck() {
        if let errorMessage = ValidHelper.validatePasswordCheck(password, passwordCheck) {
            passwordCheckErrorMessage = errorMessage
        } else {
            passwordCheckErrorMessage = ""
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
    func signUp() async throws -> SignUpResultModel {
        let userSignInfo = UserSignUpModel(id: id, nickName: nickname, password: password)
        return try await autherService.signUpService(userSignInfo: userSignInfo)
    }
}
