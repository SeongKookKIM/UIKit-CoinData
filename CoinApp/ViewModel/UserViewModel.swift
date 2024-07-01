//
//  UserViewModel.swift
//  CoinApp
//
//  Created by SeongKook on 6/30/24.
//

import Foundation
import Combine

class UserViewModel {
    
    static let shared = UserViewModel()
    
    private let autherService = AuthService()
    
    var Keychain = KeychainHelper()
    
    @Published private(set) var userInfo: UserModel?
    
    private init() {}
    
    func fetchUserInfo() {
        Task {
            do {
                // @@@@@@@@키체인 리셋
                let result = try await autherService.userLoginCheckService()
     
                 if let accessToken = result.accessToken, let refreshToken = result.refreshToken {
                     Keychain.save(accessToken, forKey: "accessToken")
                     Keychain.save(refreshToken, forKey: "refreshToken")
                 }
             
                DispatchQueue.main.async {
                    self.userInfo = result
                }
            } catch {
                print("Error fetching user info: \(error)")
            }
        }
    }
}
