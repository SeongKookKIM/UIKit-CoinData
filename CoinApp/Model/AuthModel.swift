//
//  AuthModel.swift
//  CoinApp
//
//  Created by SeongKook on 6/26/24.
//

import Foundation

struct UserSignIn: Codable {
    let nickName: String
    let id: String
    let password: String
}

struct ResultMessage: Codable {
    let isSuccess: Bool
}
