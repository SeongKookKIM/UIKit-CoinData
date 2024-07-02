//
//  LoginViewModel.swift
//  CoinApp
//
//  Created by SeongKook on 6/27/24.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    private let autherService = AuthService()
    
    // 서버에 로그인 요청
    func fetchLogin(_ id: String, _ password: String) async throws -> LoginResultModel {
        let userLoginInfo = UserLoginModel(id: id, password: password)
        return try await autherService.loginService(loginInfo: userLoginInfo)
    }
    
    func fetchLogout(_ id:String, _ nickName: String) async throws -> WidthdrawResultModel {
        let userInfo = UserModel(isLogin: true, nickName: nickName, id: id, accessToken: nil, refreshToken: nil)
        return try await autherService.logoutService(userInfo: userInfo)
    }
}

