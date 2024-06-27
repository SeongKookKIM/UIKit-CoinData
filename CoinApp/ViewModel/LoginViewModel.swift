//
//  LoginViewModel.swift
//  CoinApp
//
//  Created by SeongKook on 6/27/24.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    private let autherService = AuthService()
    
    static let shared = LoginViewModel()
    
    @Published var userInfo: UserModel = UserModel(isLogin: false, nickName: "", id: "")
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()

    private init() {}
    
    // 서버에 로그인 요청
    func login(_ id: String, _ password: String) async throws -> LoginResultModel {
        let userLoginInfo = UserLoginModel(id: id, password: password)
        return try await autherService.loginService(loginInfo: userLoginInfo)
    }
    
    // 서버에 토큰 요청 후 유저 정보가져오기
    func fetchUserInfo() {
        autherService.userLoginCheckService()
            .receive(on: RunLoop.main)
            .handleEvents(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            })
            .catch { _ in Just(UserModel(isLogin: false, nickName: "", id: "")) }
            .assign(to: &$userInfo)
    }
}

