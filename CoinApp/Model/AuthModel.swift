//
//  AuthModel.swift
//  CoinApp
//
//  Created by SeongKook on 6/26/24.
//

import Foundation

protocol UserIdentifiable {
    var id: String? { get }
    var nickName: String? { get }
}

protocol TokenIdentifiable {
    var accessToken: String? { get }
    var refreshToken: String? { get }
}

// 회원가입
struct UserSignInModel: Codable, UserIdentifiable {
    var id: String?
    var nickName: String?
    
    let password: String
}

struct SignUpResultModel: Codable {
    let isSuccess: Bool
    let failMessage: String
}

// 로그인
struct UserLoginModel: Codable {
    let id: String
    let password: String
}

struct LoginResultModel: Codable, TokenIdentifiable {
    let isSuccess: Bool
    let failMessage: String
    var accessToken: String?
    var refreshToken: String?
}

// 유저 정보
struct UserModel: Codable, TokenIdentifiable {
    let isLogin: Bool?
    let nickName: String?
    let id: String?
    var accessToken: String?
    var refreshToken: String?
}

// 로그아웃
struct WithdrawResultModel: Codable {
    let widthdrawMessage: String
}

// 회원정보 수정
struct EditProfileModel: Codable, UserIdentifiable {
    var id: String?
    var nickName: String?
    let defaultId: String
    let defaultNickname: String
    let password: String
    let newPassword: String
}

struct EditProfileResultModel: Codable, TokenIdentifiable {
    let isSuccess: Bool
    let failMessage: String
    
    var accessToken: String?
    var refreshToken: String?
}
