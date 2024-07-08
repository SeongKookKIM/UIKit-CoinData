//
//  LoginViewController.swift
//  CoinApp
//
//  Created by SeongKook on 6/25/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let loginViewModel = LoginViewModel()
    
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
        idTF.autocapitalizationType = .none
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
        passwordTF.autocapitalizationType = .none
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
    
    // tap 제스처
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(hanlderTapGeture))
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupButtonTap()
    }
    
    // Memory TapGestures
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.removeGestureRecognizer(tapGesture)
    }
    
    
    // setupUI
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
        
        setupLayout()
    }
    
    // setupLayout Contraint
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
    
    // Button Actions
    func setupButtonTap() {
        loginButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            
            self.idTF.resignFirstResponder()
            self.passwordTF.resignFirstResponder()
            
            Task {
                do {
                    let result = try await self.loginViewModel.fetchLogin(self.idTF.text ?? "", self.passwordTF.text ?? "")
                    DispatchQueue.main.async {
                        if result.isSuccess {
                            self.showAlert(result.failMessage) {
                                UserViewModel.shared.fetchUserInfo()
                                
                                if let tabBarController = self.tabBarController {
                                    tabBarController.selectedIndex = 0
                                }
                            }
                        } else {
                            self.showAlert(result.failMessage, completion: nil)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("에러 발생: \(error)")
                    }
                }
            }
            
        }, for: .touchUpInside)
        
        signButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            
            self.idTF.resignFirstResponder()
            self.passwordTF.resignFirstResponder()
            
            let signInVC = SignInViewController()
            self.navigationController?.pushViewController(signInVC, animated: true)
            
        }, for: .touchUpInside)
    }
    
    // Tap Hanlder
    @objc func hanlderTapGeture(_ sender: UIView) {
        idTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
    
    // 로그인시 알림
    func showAlert(_ message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: "로그인", message: message, preferredStyle: .alert)
        let confirmBtn = UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        }
        alert.addAction(confirmBtn)
        self.present(alert, animated: true, completion: nil)
    }
}

// TextFiled Tap Gesture
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
