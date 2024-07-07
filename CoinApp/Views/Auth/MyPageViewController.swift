//
//  MyPageViewController.swift
//  CoinApp
//
//  Created by SeongKook on 6/27/24.
//

import UIKit

class MyPageViewController: UIViewController {
    
    var Keychain = KeychainHelper()
    
    private let loginViewModel = LoginViewModel()
    
    // User Info
    private let welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        welcomeLabel.textColor = .black
        welcomeLabel.text = "반갑습니다."
        welcomeLabel.textAlignment = .center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return welcomeLabel
    }()
    
    private let userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        userNameLabel.textColor = .systemBlue
        userNameLabel.textAlignment = .center
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return userNameLabel
    }()
    
    private let userBookmarkLabel: UILabel = {
        let userBookmarkLabel = UILabel()
        userBookmarkLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        userBookmarkLabel.textColor = .black
        userBookmarkLabel.text = "현재 내 북마크 갯수는 0개 입니다."
        userBookmarkLabel.textAlignment = .left
        userBookmarkLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return userBookmarkLabel
    }()
    
    // Logout Btn
    private let logoutButton: UIButton = {
        let loginButton = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        config.title = "로그아웃"
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
        loginButton.configuration = config
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        return loginButton
    }()
    
    // 탈퇴 Btn
    private let withdrawButton: UIButton = {
        let withdrawButton = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        config.title = "탈퇴하기"
        config.baseBackgroundColor = .systemRed
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
        withdrawButton.configuration = config
        
        withdrawButton.translatesAutoresizingMaskIntoConstraints = false
        
        return withdrawButton
    }()
    
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        setupBindData()
        setupButtonAction()
    }
    
    
    // setupUI
    func setupUI() {
        self.title = "MYPAGE"
        self.view.backgroundColor = .white
        
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(userNameLabel)
        self.view.addSubview(userBookmarkLabel)
        self.view.addSubview(logoutButton)
        self.view.addSubview(withdrawButton)
        setupLayout()
    }
    
    // setupLayout
    func setupLayout() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            welcomeLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -130),
            welcomeLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            userNameLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            userBookmarkLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 30),
            userBookmarkLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            logoutButton.topAnchor.constraint(equalTo: userBookmarkLabel.bottomAnchor, constant: 50),
            logoutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            withdrawButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 20),
            withdrawButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
    
    // setupBind UserInfo
    func setupBindData() {
        userNameLabel.text = "\(UserViewModel.shared.userInfo?.nickName ?? "")님"
    }
    
    // Button Actions
    func setupButtonAction() {
        logoutButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.showAlert("로그아웃", "로그아웃 하시겠습니까?", check: false) {
                if let tabBarController = self.tabBarController {
//                    self.Keychain.delete("accessToken")
//                    self.Keychain.delete("refreshToken")
//                     UserViewModel.shared.fetchUserInfo()
                    UserViewModel.shared.logout()
                    
                    tabBarController.selectedIndex = 0
                } else {
                    print("Tab bar controller is nil")
                }
            }
        }, for: .touchUpInside)
        
        withdrawButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.showAlert("회원탈퇴", "회원을 탈퇴 하시겠습니까?", check: true) {
                if let tabBarController = self.tabBarController {
                    Task {
                        do {
                            let result = try await self.loginViewModel.fetchLogout(UserViewModel.shared.userInfo?.id ?? "", UserViewModel.shared.userInfo?.nickName ?? "")
                            
                            self.Keychain.delete("accessToken")
                            self.Keychain.delete("refreshToken")
                            UserViewModel.shared.fetchUserInfo()
                            
                            self.showAlert("회원탈퇴 진행완료", result.widthdrawMessage, check: false) {
                                DispatchQueue.main.async {
                                    tabBarController.selectedIndex = 0
                                }
                            }
                            
                            
                        } catch {
                            DispatchQueue.main.async {
                                print("에러 발생: \(error)")
                            }
                        }
                    }
                    
                    // tabBarController.selectedIndex = 0
                } else {
                    print("Tab bar controller is nil")
                }
            }
        }, for: .touchUpInside)
    }
    
    
    // 로그아웃시 알림
    func showAlert(_ title: String, _ message: String , check: Bool , completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmBtn = UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        }
        
        if check {
            let cancelBtn = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(cancelBtn)
        }
        
        alert.addAction(confirmBtn)
        self.present(alert, animated: true, completion: nil)
    }
    
}
