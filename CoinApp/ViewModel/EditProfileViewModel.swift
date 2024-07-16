//
//  EditProfileViewModel.swift
//  CoinApp
//
//  Created by SeongKook on 7/16/24.
//

import Foundation

class EditProfileViewModel {
    private var keychain = KeychainHelper()
    private let autherService = AuthService()
    
    // 유효성 검사
    var nickname: String = UserViewModel.shared.userInfo?.nickName ?? "" {
        didSet { validateNickname() }
    }
    
    var id: String = UserViewModel.shared.userInfo?.id ?? "" {
        didSet { validateID() }
    }
    
    var password: String = "" {
        didSet { validatePassword() }
    }
    
    var newPassword: String = "" {
        didSet { validateNewPassword() }
    }
    
    var newPasswordCheck: String = "" {
        didSet { validateNewPasswordCheck() }
    }
    
    var isFormValid: Bool = false
    
    // 에러 메세지
    var nicknameErrorMessage: String = ""
    var idErrorMessage: String = ""
    var passwordErrorMessage: String = ""
    var newPasswordErrorMessage: String = ""
    var newPasswordCheckErrorMessage: String = ""
    
    // 유효성 검사 메서드
    // 정규식 패턴 확인
    private func validateNickname() {
        if let errorMessage = ValidHelper.validateNickname(nickname) {
            nicknameErrorMessage = errorMessage
        } else {
            nicknameErrorMessage = ""
        }
        validateForm()
    }
    
    private func validateID() {
        if let errorMessage = ValidHelper.validateID(id) {
            idErrorMessage = errorMessage
        } else {
            idErrorMessage = ""
        }
        validateForm()
    }
    
    private func validatePassword() {
        if let errorMessage = ValidHelper.validatePasswordEmpty(password) {
            passwordErrorMessage = errorMessage
        } else {
            passwordErrorMessage = ""
        }
        validateForm()
    }
    
    private func validateNewPassword() {
        if let errorMessage = ValidHelper.validatePassword(newPassword) {
            newPasswordErrorMessage = errorMessage
        } else {
            newPasswordErrorMessage = ""
        }
        validateForm()
    }
    
    private func validateNewPasswordCheck() {
        if let errorMessage = ValidHelper.validatePasswordCheck(newPassword, newPasswordCheck) {
            newPasswordCheckErrorMessage = errorMessage
        } else {
            newPasswordCheckErrorMessage = ""
        }
        validateForm()
    }
    
    // 유효성 통과시 버튼 활성화 함수
    private func validateForm() {
        isFormValid = nicknameErrorMessage.isEmpty &&
        idErrorMessage.isEmpty &&
        passwordErrorMessage.isEmpty &&
        newPasswordErrorMessage.isEmpty &&
        newPasswordCheckErrorMessage.isEmpty &&
        !nickname.isEmpty &&
        !id.isEmpty &&
        !password.isEmpty &&
        !newPassword.isEmpty &&
        !newPasswordCheck.isEmpty
    }
    
    // 서버에 회원정보 수정 요청
    func editProfile(defaultUserId: String, defaultUserNickname: String) async throws -> EditProfileResultModel {
        
        let userEditProfileInfo = EditProfileModel(id: id, nickName: nickname, defaultId: defaultUserId, defaultNickname: defaultUserNickname, password: password, newPassword: newPassword)
        let result = try await autherService.userEditProfileService(userEditProfileInfo: userEditProfileInfo)
        
        if result.isSuccess, let accessToken = result.accessToken, let refreshToken = result.refreshToken {
            keychain.save(accessToken, forKey: "accessToken")
            keychain.save(refreshToken, forKey: "refreshToken")
        }
        
        return result
    }
}
