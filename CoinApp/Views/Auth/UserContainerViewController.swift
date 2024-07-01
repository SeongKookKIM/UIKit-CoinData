//
//  UserContainerViewController.swift
//  CoinApp
//
//  Created by SeongKook on 7/2/24.
//

import UIKit
import Combine

class UserContainerViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UserViewModel의 userInfo 상태를 관찰
        UserViewModel.shared.$userInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userInfo in
                self?.updateViewController(isLoggedIn: userInfo?.isLogin ?? false)
            }
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 뷰가 나타날 때마다 사용자 정보를 새로 가져옴
        UserViewModel.shared.fetchUserInfo()
    }
    
    private func updateViewController(isLoggedIn: Bool) {
        let viewController: UIViewController
        
        if isLoggedIn {
            viewController = MyPageViewController()
        } else {
            viewController = LoginViewController()
        }
        
        // 현재 표시된 뷰 컨트롤러를 제거
        if let currentVC = children.first {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }
        
        // 새 뷰 컨트롤러 추가
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.didMove(toParent: self)
    }
}
