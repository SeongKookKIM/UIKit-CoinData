//
//  AutherService.swift
//  CoinApp
//
//  Created by SeongKook on 6/26/24.
//

import Foundation

class AuthService {
    
    // signIn Server
    func signInService(userSignInfo: UserSignInModel) async throws -> SingInResultModel {
        guard let url = URL(string: "http://localhost:8080/auth/signIn") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(userSignInfo)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(SingInResultModel.self, from: data)
        
        return result
    }
    
    // Login Server
    func loginService(loginInfo: UserLoginModel) async throws -> LoginResultModel {
        guard let url = URL(string: "http://localhost:8080/auth/login") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(loginInfo)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(LoginResultModel.self, from: data)
        
        if result.isSuccess, let accessToken = result.accessToken, let refreshToken = result.refreshToken {
            KeychainHelper.shared.save(accessToken, forKey: "accessToken")
            KeychainHelper.shared.save(refreshToken, forKey: "refreshToken")
        }
        
        return result
    }
    
    // AcessToken확인
    func userLoginCheckService() async throws -> UserModel {
        guard let url = URL(string: "http://localhost:8080/auth/loginCheck") else {
            throw URLError(.badURL)
        }
        
        guard let accessToken = KeychainHelper.shared.get("accessToken"),
              let refreshToken = KeychainHelper.shared.get("refreshToken") else {
            throw APIError.invalidRequestError("토큰이 존재하지 않습니다.")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Refresh-Token")
        
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(UserModel.self, from: data)
        
        return result
    }
    
}
