//
//  LoginViewController.swift
//  CoinApp
//
//  Created by SeongKook on 6/25/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    private lazy var loginStack: UIStackView = {
       let loginStack = UIStackView()
        loginStack.axis = .vertical
        loginStack.spacing = 20
        loginStack.alignment = .center
        loginStack.distribution = .fillEqually
        loginStack.translatesAutoresizingMaskIntoConstraints = false
        
        return loginStack
    }()
    
    private lazy var loginTitleLabel: UILabel = {
       let loginTitleLabel = UILabel()
        loginTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        loginTitleLabel.textColor = .gray
        loginTitleLabel.text = "로그인"
        loginTitleLabel.textAlignment = .center
        loginTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return loginTitleLabel
    }()
    
    private lazy var idTF: UITextField = {
        let idTF = UITextField()
        idTF.placeholder = "아이디를 입력해주세요."
        idTF.borderStyle = .roundedRect
        idTF.translatesAutoresizingMaskIntoConstraints = false
        
        return idTF
    }()
    
    private let passwordTF: UITextField = {
        let passwordTF = UITextField()
        passwordTF.placeholder = "비밀번호"
        passwordTF.isSecureTextEntry = true
        passwordTF.borderStyle = .roundedRect
        passwordTF.translatesAutoresizingMaskIntoConstraints = false
        
        return passwordTF
    }()
    
    private let loginButton: UIButton = {
        let loginButton = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        config.title = "로그인"
        config.baseBackgroundColor = .blue
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        loginButton.configuration = config

        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        return loginButton
    }()
    
    private let signButton: UIButton = {
        let signButton = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        config.title = "회원가입"
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        signButton.configuration = config
        
        signButton.translatesAutoresizingMaskIntoConstraints = false
        
        return signButton
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

    }
    
    func setupUI() {
        self.title = "로그인"
        self.view.backgroundColor = .white
        self.view.addSubview(loginTitleLabel)
        self.view.addSubview(loginStack)
        
        loginStack.addArrangedSubview(idTF)
        loginStack.addArrangedSubview(passwordTF)
        loginStack.addArrangedSubview(loginButton)
        loginStack.addArrangedSubview(signButton)
        
        signButton.addAction(UIAction { [weak self] _ in
            print("회원가입")
        }, for: .touchUpInside)
        
        setupLayout()
    }
    
    func setupLayout() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            loginStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -50),
            loginStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 50),
            loginStack.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            loginStack.heightAnchor.constraint(equalToConstant: 200),
            
            loginTitleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -50),
            loginTitleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 50),
            loginTitleLabel.bottomAnchor.constraint(equalTo: loginStack.topAnchor, constant: -20),
            
            idTF.widthAnchor.constraint(equalTo: loginStack.widthAnchor),
            passwordTF.widthAnchor.constraint(equalTo: loginStack.widthAnchor),
            loginButton.widthAnchor.constraint(equalTo: loginStack.widthAnchor),
            signButton.widthAnchor.constraint(equalTo: loginStack.widthAnchor)
            
        ])
    }
}
