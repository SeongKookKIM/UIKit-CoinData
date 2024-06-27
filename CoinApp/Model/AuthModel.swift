//
//  AuthModel.swift
//  CoinApp
//
//  Created by SeongKook on 6/26/24.
//

import Foundation

struct UserSignInModel: Codable {
    let nickName: String
    let id: String
    let password: String
}

struct SingInResultModel: Codable {
    let isSuccess: Bool
    let failMessage: String
}

struct UserLoginModel: Codable {
    let id: String
    let password: String
}

struct LoginResultModel: Codable {
    let isSuccess: Bool
    let failMessage: String
    let accessToken: String?
    let refreshToken: String?
}
