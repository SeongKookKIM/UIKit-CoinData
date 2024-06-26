//
//  AutherService.swift
//  CoinApp
//
//  Created by SeongKook on 6/26/24.
//

import Foundation

class AuthService {
    
    // signIn Server
    func signIn(userSignInfo: UserSignIn) async throws -> Bool {
        guard let url = URL(string: "http://localhost:8080/signIn") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(userSignInfo)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(ResultMessage.self, from: data)
        
        return result.isSuccess
    }
}
