//
//  SplashViewController.swift
//  CoinApp
//
//  Created by SeongKook on 6/25/24.
//

import UIKit
import Combine

class SplashViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    // imageView
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "CoinLogo"))
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIdentifier = "splashImageView"
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 2초 후에 메인 화면으로 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showMainView()
        }
    }
    
    // setupUI
    private func setupUI() {
        self.view.backgroundColor = UIColor(red: 189/255, green: 197/255, blue: 201/255, alpha: 1)
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    
    
    
    // tabBarController
    private func showMainView() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            return
        }
        
        let firstViewController = UINavigationController(rootViewController: CoinListViewController())
        let secondViewController = UINavigationController(rootViewController: MyCoinViewController())
        let thirdViewController = UINavigationController(rootViewController: UserContainerViewController())
        
        
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([firstViewController, secondViewController, thirdViewController], animated: true)
        
        if let items = tabBarController.tabBar.items {
            items[0].selectedImage = UIImage(systemName: "bitcoinsign.circle.fill")
            items[0].image = UIImage(systemName: "bitcoinsign.circle")
            items[0].title = "Coin List"
            
            items[1].selectedImage = UIImage(systemName: "bookmark.fill")
            items[1].image = UIImage(systemName: "bookmark")
            items[1].title = "Coin Bookmark List"
            
            items[2].selectedImage = UIImage(systemName: "person.fill")
            items[2].image = UIImage(systemName: "person")
            items[2].title = "User"
        }
        
        let selectedColor = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        let unselectedColor = UIColor.gray
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
        UITabBar.appearance().tintColor = selectedColor
        UITabBar.appearance().unselectedItemTintColor = unselectedColor
        UITabBar.appearance().backgroundColor = .systemBackground
        
        window.rootViewController = tabBarController
        UIView.transition(with: window, duration: 0.7, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}


