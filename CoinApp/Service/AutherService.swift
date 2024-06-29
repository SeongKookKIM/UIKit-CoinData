//
//  AutherService.swift
//  CoinApp
//
//  Created by SeongKook on 6/26/24.
//

import Foundation
import Combine

class AuthService {
    
    var Keychain = KeychainHelper()
    
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
            Keychain.save(accessToken, forKey: "accessToken")
            Keychain.save(refreshToken, forKey: "refreshToken")
        }
        
        return result
    }
    

    func userLoginCheckService() -> AnyPublisher<UserModel, Error> {
        guard let url = URL(string: "http://localhost:8080/auth/loginCheck") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        guard let accessToken = Keychain.get("accessToken"),
              let refreshToken = Keychain.get("refreshToken") else {
            return Fail(error: "토큰이 존재하지 않습니다." as! Error).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Refresh-Token")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .mapError { error -> Error in
                return APIError.transportError(error)
            }
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                guard let urlResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                if (200..<300) ~= urlResponse.statusCode { }
                else {
                    let decoder = JSONDecoder()
                    let apiError = try decoder.decode(APIErrorMessage.self, from: data)
                    
                    if urlResponse.statusCode == 400 {
                        throw APIError.validationError(apiError.reason)
                    }
                }
                return (data, response)
            }
        
            .map(\.data)
            .decode(type: UserModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
