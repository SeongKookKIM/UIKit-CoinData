//
//  AuthModel.swift
//  CoinApp
//
//  Created by SeongKook on 6/26/24.
//

import Foundation

// 회원가입
struct UserSignInModel: Codable {
    let nickName: String
    let id: String
    let password: String
}

struct SingInResultModel: Codable {
    let isSuccess: Bool
    let failMessage: String
}

// 로그인
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

// 유저 정보
struct UserModel: Codable {
    let isLogin: Bool
    let nickName: String?
    let id: String?
    let accessToken: String?
    let refreshToken: String?
}
