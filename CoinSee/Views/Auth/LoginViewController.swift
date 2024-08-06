//
//  LoginViewController.swift
//  CoinApp
//
//  Created by SeongKook on 6/25/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let loginViewModel = LoginViewModel()
    
    // Views
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
        return UILabel.createLabel(fontSize: 24, fontWeight: .bold, textColor: .gray, text: "로그인", align: .center)
    }()
    
    private lazy var idTF: UITextField = {
        return UITextField.createTextField(fontSize: 16, placeholder: "아이디를 입력해주세요.", placeholderFontSize: 14, isSecure: false, testIdentifiler: "usernameTextField")
    }()
    
    private let passwordTF: UITextField = {
        return UITextField.createTextField(fontSize: 16, placeholder: "비밀번호를 입력해주세요.", placeholderFontSize: 14, isSecure: true, testIdentifiler: "passwordTextField")
    }()
    
    private let loginButton: UIButton = {
        return UIButton.createButton(title: "로그인", backgroundColor: .blue, foregroundColor: .white, testIdentifiler: "loginButton")
    }()
    
    private let signButton: UIButton = {
        return UIButton.createButton(title: "회원가입", backgroundColor: .systemBlue, foregroundColor: .white, testIdentifiler: "signUpButton")
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
    private func setupUI() {
        self.view.accessibilityIdentifier = "LoginView"
        
        self.view.backgroundColor = .systemBackground
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
    private func setupLayout() {
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
    private func setupButtonTap() {
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
            
            let signUpVC = SignUpViewController()
            self.navigationController?.pushViewController(signUpVC, animated: true)
            
        }, for: .touchUpInside)
    }
    
    // Tap Hanlder
    @objc func hanlderTapGeture(_ sender: UIView) {
        idTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
    
    // 로그인시 알림
    private func showAlert(_ message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: "로그인", message: message, preferredStyle: .alert)
        let confirmBtn = UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        }
        alert.addAction(confirmBtn)
        alert.view.accessibilityIdentifier = "loginAlert"
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
