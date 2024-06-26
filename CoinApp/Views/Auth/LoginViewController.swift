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
        loginTitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        loginTitleLabel.textColor = .gray
        loginTitleLabel.text = "로그인"
        loginTitleLabel.textAlignment = .center
        loginTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return loginTitleLabel
    }()
    
    private lazy var idTF: UITextField = {
        let idTF = UITextField()
        idTF.font = UIFont.systemFont(ofSize: 16)
        idTF.attributedPlaceholder = NSAttributedString(
            string: "아이디를 입력해주세요.",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
        )
        idTF.borderStyle = .roundedRect
        idTF.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 6.0, height: 0.0))
        idTF.leftViewMode = .always
        idTF.translatesAutoresizingMaskIntoConstraints = false
        
        return idTF
    }()
    
    private let passwordTF: UITextField = {
        let passwordTF = UITextField()
        passwordTF.font = UIFont.systemFont(ofSize: 16)
        passwordTF.attributedPlaceholder = NSAttributedString(
            string: "비밀번호를 입력해주세요.",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
        )
        passwordTF.isSecureTextEntry = true
        passwordTF.textContentType = .oneTimeCode
        passwordTF.borderStyle = .roundedRect
        passwordTF.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 6.0, height: 0.0))
        passwordTF.leftViewMode = .always
        passwordTF.translatesAutoresizingMaskIntoConstraints = false
        
        return passwordTF
    }()
    
    private let loginButton: UIButton = {
        let loginButton = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        config.title = "로그인"
        config.baseBackgroundColor = .blue
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
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
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
        signButton.configuration = config
        
        signButton.translatesAutoresizingMaskIntoConstraints = false
        
        return signButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(loginTitleLabel)
        self.view.addSubview(loginStack)
        
        loginStack.addArrangedSubview(idTF)
        loginStack.addArrangedSubview(passwordTF)
        loginStack.addArrangedSubview(loginButton)
        loginStack.addArrangedSubview(signButton)
        
        idTF.delegate = self
        passwordTF.delegate = self
        
        signButton.addAction(UIAction { [weak self] _ in
            let signInVC = SignInViewController()
            self?.navigationController?.pushViewController(signInVC, animated: true)
            
        }, for: .touchUpInside)
        
        setupLayout()
    }
    
    func setupLayout() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            loginStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -50),
            loginStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 50),
            loginStack.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            loginStack.heightAnchor.constraint(equalToConstant: 300),
            
            loginTitleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -50),
            loginTitleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 50),
            loginTitleLabel.bottomAnchor.constraint(equalTo: loginStack.topAnchor, constant: -40),
            
            idTF.widthAnchor.constraint(equalTo: loginStack.widthAnchor),

            passwordTF.widthAnchor.constraint(equalTo: loginStack.widthAnchor),

            loginButton.widthAnchor.constraint(equalTo: loginStack.widthAnchor),

            signButton.widthAnchor.constraint(equalTo: loginStack.widthAnchor)
            
        ])
    }
}

extension LoginViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemBlue.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.clear.cgColor
    }
}
