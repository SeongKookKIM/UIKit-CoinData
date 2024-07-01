//
//  MyCoinViewController.swift
//  CoinApp
//
//  Created by SeongKook on 6/25/24.
//

import UIKit
import Combine

class MyCoinViewController: UIViewController {
    
    var Keychain = KeychainHelper()
//    private let userViewModel = UserViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var testALabel = UILabel()
    private lazy var testBLabel = UILabel()
    private lazy var testCLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        if let accessToken = Keychain.get("accessToken") {
            testALabel.text = accessToken
        } else {
            testALabel.text = "accessToken none"
        }

        if let refreshToken = Keychain.get("refreshToken") {
            testBLabel.text = refreshToken
        } else {
            testBLabel.text = "refreshToken none"
        }
        
        
        setupLayout()
        
//        Task {
//            try await print(userViewModel.fetchUserInfo())
//            testCLabel.text = try await userViewModel.fetchUserInfo().nickName
//        }
        
        // 데이터 가져오기
        UserViewModel.shared.fetchUserInfo()
        
        // userInfo 변경 관찰하기
        UserViewModel.shared.$userInfo
            .sink { [weak self] userInfo in
                if let userInfo = userInfo {
                    self?.testCLabel.text = userInfo.nickName
                }
            }
            .store(in: &cancellables)
        
    }
    
    private func setupLayout() {
        testALabel.translatesAutoresizingMaskIntoConstraints = false
        testBLabel.translatesAutoresizingMaskIntoConstraints = false
        testCLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(testALabel)
        self.view.addSubview(testBLabel)
        self.view.addSubview(testCLabel)
        
        NSLayoutConstraint.activate([
            testALabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            testALabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            testBLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            testBLabel.topAnchor.constraint(equalTo: testALabel.bottomAnchor, constant: 40),
            
            testCLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            testCLabel.topAnchor.constraint(equalTo: testBLabel.bottomAnchor, constant: 40),
        ])
    }
    

}
