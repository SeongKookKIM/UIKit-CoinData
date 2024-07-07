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
    
    @Published var userInfo: UserModel?
    @Published var isLoggedIn: Bool = false
    
    private init() {
        $userInfo
            .map { $0 != nil }
            .assign(to: &$isLoggedIn)
    }
    
    func fetchUserInfo() {
        Task {
            do {
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
    
    func logout() {
        Keychain.delete("accessToken")
        Keychain.delete("refreshToken")
        fetchUserInfo()
        
        userInfo = nil // 로그아웃 시 userInfo를 nil로 설정
    }
}
