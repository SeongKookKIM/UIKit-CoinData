//
//  LoginViewModel.swift
//  CoinApp
//
//  Created by SeongKook on 6/27/24.
//

import Foundation

class LoginViewModel {
    private let autherService = AuthService()

    
    // 서버에 로그인 요청
    func login(_ id: String, _ password: String) async throws -> LoginResultModel {
        let userLoginInfo = UserLoginModel(id: id, password: password)
        return try await autherService.loginService(loginInfo: userLoginInfo)
    }
    
    // 서버에 토큰 요청 후 유저 정보가져오기
    func userInfo() async throws -> UserModel {
        return try await autherService.userLoginCheckService()
    }
}

