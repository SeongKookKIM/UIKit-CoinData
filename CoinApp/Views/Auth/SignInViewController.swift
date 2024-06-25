//
//  SignInViewController.swift
//  CoinApp
//
//  Created by SeongKook on 6/25/24.
//

import UIKit

class SignInViewController: UIViewController {
    
    private let nickNameLabel: UILabel = {
       let nickNameLabel = UILabel()
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return nickNameLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "회원가입"
        self.view.backgroundColor = .white

     
    }
}
