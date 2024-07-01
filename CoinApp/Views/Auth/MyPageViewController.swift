//
//  MyPageViewController.swift
//  CoinApp
//
//  Created by SeongKook on 6/27/24.
//

import UIKit

class MyPageViewController: UIViewController {
    
    var Keychain = KeychainHelper()
    
    private let logoutButton: UIButton = {
        let loginButton = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        config.title = "로그아웃"
        config.baseBackgroundColor = .blue
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
        loginButton.configuration = config
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        return loginButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "MYPAGE"
        self.view.backgroundColor = .white
        
        self.view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        logoutButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.showAlert() {
                if let tabBarController = self.tabBarController {
                    self.Keychain.delete("accessToken")
                    self.Keychain.delete("refreshToken")
                    UserViewModel.shared.fetchUserInfo()

                    tabBarController.selectedIndex = 0
                }
            }
        }, for: .touchUpInside)
    }
    

    // 로그아웃시 알림
    func showAlert(completion: (() -> Void)?) {
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let confirmBtn = UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        }
        alert.addAction(confirmBtn)
        self.present(alert, animated: true, completion: nil)
    }

}
