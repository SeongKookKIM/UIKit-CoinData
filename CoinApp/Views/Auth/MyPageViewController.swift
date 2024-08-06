//
//  MyPageViewController.swift
//  CoinApp
//
//  Created by SeongKook on 6/27/24.
//

import UIKit
import Combine

class MyPageViewController: UIViewController {
    
    var Keychain = KeychainHelper()
    
    private let loginViewModel = LoginViewModel()
    private var coinViewModel = CoinViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // User Info
    private let welcomeLabel: UILabel = {
        return UILabel.createLabel(fontSize: 18, fontWeight: .bold, textColor: .black, text: "반갑습니다.", align: .center)
    }()
    
    private let userNameLabel: UILabel = {
        return UILabel.createLabel(fontSize: 22, fontWeight: .bold, textColor: .systemBlue, text: "", align: .center)
    }()
    
    private let userBookmarkLabel: UILabel = {
        return UILabel.createLabel(fontSize: 22, fontWeight: .bold, textColor: .black, text: "현재 내 북마크 갯수는 0개 입니다.", align: .left)
    }()
    
    // Logout Btn
    private let logoutButton: UIButton = {
        return UIButton.createButton(title: "로그아웃", backgroundColor: .systemBlue, foregroundColor: .white, testIdentifiler: "logoutBtn")
    }()
    
    // 회원정보 수정 Btn
    private let editButton: UIButton = {
        return UIButton.createButton(title: "정보수정", backgroundColor: .systemGray, foregroundColor: .white, testIdentifiler: "editProfileBtn")
    }()
    
    // 탈퇴 Btn
    private let withdrawButton: UIButton = {
        return UIButton.createButton(title: "탈퇴하기", backgroundColor: .systemRed, foregroundColor: .white, testIdentifiler: "withdrawBtn")
    }()
    
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        fetchBookmarks()
        setupBindData()
        setupButtonAction()
    }
    
    
    // setupUI
    private func setupUI() {
        self.title = "MYPAGE"
        self.view.backgroundColor = .systemBackground
        self.view.accessibilityIdentifier = "MyPageView"
        
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(userNameLabel)
        self.view.addSubview(userBookmarkLabel)
        self.view.addSubview(logoutButton)
        self.view.addSubview(editButton)
        self.view.addSubview(withdrawButton)
        setupLayout()
    }
    
    // setupLayout
    private func setupLayout() {
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
            
            editButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 20),
            editButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            withdrawButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            withdrawButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
    
    // setupBind UserInfo
    private func setupBindData() {
        userNameLabel.text = "\(UserViewModel.shared.userInfo?.nickName ?? "")님"
        
        coinViewModel.$bookmarkList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookmarks in
                guard let self = self else { return }
                self.userBookmarkLabel.text = "현재 내 북마크 갯수는 \(bookmarks.count)개 입니다."
            }
            .store(in: &cancellables)
    }
    
    // fetchBookmarks
    private func fetchBookmarks() {
        Task {
            do {
                if let userId = UserViewModel.shared.userInfo?.id,
                   let userNickname = UserViewModel.shared.userInfo?.nickName {
                    let bookmarks = try await coinViewModel.fetchCheckBookmark(userId: userId, userNickname: userNickname)
                    DispatchQueue.main.async {
                        self.coinViewModel.bookmarkList = bookmarks
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.coinViewModel.bookmarkList = []
                }
                print("Error fetching bookmarks: \(error)")
            }
        }
    }
    
    // Button Actions
    private func setupButtonAction() {
        logoutButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.showAlert("로그아웃", "로그아웃 하시겠습니까?", check: false) {
                if let tabBarController = self.tabBarController {
                    UserViewModel.shared.removeUserInfo()
                    
                    tabBarController.selectedIndex = 0
                } else {
                    print("Tab bar controller is nil")
                }
            }
        }, for: .touchUpInside)
        
        editButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            
            let editProfileVC = EditProfileViewController()
            self.navigationController?.pushViewController(editProfileVC, animated: true)
        }, for: .touchUpInside)
        
        withdrawButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.showAlert("회원탈퇴", "회원을 탈퇴 하시겠습니까?", check: true) {
                if let tabBarController = self.tabBarController {
                    Task {
                        do {
                            let result = try await self.loginViewModel.fetchLogout(UserViewModel.shared.userInfo?.id ?? "", UserViewModel.shared.userInfo?.nickName ?? "")
                            
                            UserViewModel.shared.removeUserInfo()
                            
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
                } else {
                    print("Tab bar controller is nil")
                }
            }
        }, for: .touchUpInside)
    }
    
    
    // 로그아웃시 알림
    private func showAlert(_ title: String, _ message: String , check: Bool , completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmBtn = UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        }
        
        if check {
            let cancelBtn = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(cancelBtn)
        }
        
        alert.addAction(confirmBtn)
        alert.view.accessibilityIdentifier = "withdrawAlert"
        self.present(alert, animated: true, completion: nil)
    }
    
}
