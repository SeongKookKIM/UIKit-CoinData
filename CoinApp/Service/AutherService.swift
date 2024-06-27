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
        
        return result
    }
}
