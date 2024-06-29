//
//  UserViewModel.swift
//  CoinApp
//
//  Created by SeongKook on 6/30/24.
//

import Foundation
import Combine

class UserViewModel {
    
    private let autherService = AuthService()
    
    func fetchUserInfo() async throws -> UserModel {
        return try await autherService.userLoginCheckService()
    }
}
