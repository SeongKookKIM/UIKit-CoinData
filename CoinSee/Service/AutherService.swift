//
//  AutherService.swift
//  CoinApp
//
//  Created by SeongKook on 6/26/24.
//

import Foundation

class AuthService {
    
    var keychain = KeychainHelper()
    private let serviceHelper = ServiceHelper()

    
    // signUp Server
    func signUpService(userSignInfo: UserSignUpModel) async throws -> SignUpResultModel {
        let request = try serviceHelper.createRequest(urlString: "http://localhost:8080/auth/signUp", method: "POST", body: try JSONEncoder().encode(userSignInfo))
        return try await serviceHelper.sendRequest(request)
    }
    
    // Login Server
    func loginService(loginInfo: UserLoginModel) async throws -> LoginResultModel {
        let request = try serviceHelper.createRequest(urlString: "http://localhost:8080/auth/login", method: "POST", body: try JSONEncoder().encode(loginInfo))
        let result: LoginResultModel = try await serviceHelper.sendRequest(request)
        
        if result.isSuccess, let accessToken = result.accessToken, let refreshToken = result.refreshToken {
            keychain.save(accessToken, forKey: "accessToken")
            keychain.save(refreshToken, forKey: "refreshToken")
        }
        
        return result
    }
    

    // UserLogin TokenCheck
    func userLoginCheckService() async throws -> UserModel {
        guard let accessToken = keychain.get("accessToken"),
              let refreshToken = keychain.get("refreshToken") else {
            print(APIError.invalidRequestError("토큰이 존재하지 않습니다."))
            return UserModel(isLogin: false, nickName: nil, id: nil, accessToken: nil, refreshToken: nil)
        }
        
        var request = try serviceHelper.createRequest(urlString: "http://localhost:8080/auth/loginCheck", method: "POST")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Refresh-Token")
        
        return try await serviceHelper.sendRequest(request)
    }
    
    // Logout
    func logoutService(userInfo: UserModel) async throws -> WithdrawResultModel {
        let request = try serviceHelper.createRequest(urlString: "http://localhost:8080/auth/withdraw", method: "POST", body: try JSONEncoder().encode(userInfo))
        return try await serviceHelper.sendRequest(request)
    }
    
    // EditProfile
    func userEditProfileService(userEditProfileInfo: EditProfileModel) async throws -> EditProfileResultModel {
        let request = try serviceHelper.createRequest(urlString: "http://localhost:8080/auth/editProfile", method: "POST", body: try JSONEncoder().encode(userEditProfileInfo))
        return try await serviceHelper.sendRequest(request)
    }
}
