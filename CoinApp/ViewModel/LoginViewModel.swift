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
}

