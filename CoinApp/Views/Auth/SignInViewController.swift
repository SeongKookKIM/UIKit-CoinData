//
//  SignInViewController.swift
//  CoinApp
//
//  Created by SeongKook on 6/25/24.
//

import UIKit

class SignInViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        return contentView
    }()
    
    private lazy var nickNameLabel: UILabel = createLabel(text: "닉네임")
    private lazy var nickNameTF: UITextField = createTextField(placeholder: "2자이상 입력해주세요.")
    private lazy var nickNameErrorMessage: UILabel = createErrorMessageLabel()
    
    private lazy var idLabel: UILabel = createLabel(text: "아이디")
    private lazy var idTF: UITextField = createTextField(placeholder: "영문 숫자 조합 6자 이상")
    private lazy var idErrorMessage: UILabel = createErrorMessageLabel()
    
    private lazy var passwordLabel: UILabel = createLabel(text: "비밀번호")
    private lazy var passwordTF: UITextField = createTextField(placeholder: "영어 소문자, 대문자, 특수기호 포함 8자 이상", isSecure: true)
    private lazy var passwordErrorMessage: UILabel = createErrorMessageLabel()
    
    private lazy var passwordCheckLabel: UILabel = createLabel(text: "비밀번호 확인")
    private lazy var passwordCheckTF: UITextField = createTextField(placeholder: "비밀번호를 다시 입력해주세요.", isSecure: true)
    private lazy var passwordCheckErrorMessage: UILabel = createErrorMessageLabel()
    
    private lazy var submitButton: UIButton = {
        let submitButton = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        config.title = "가입하기"
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
        
        submitButton.configuration = config
        submitButton.isEnabled = false
        submitButton.alpha = 0.5
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
        return submitButton
    }()
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .gray
        label.text = text
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    func createTextField(placeholder: String, isSecure: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
        )
        textField.borderStyle = .roundedRect
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 6.0, height: 0.0))
        textField.leftViewMode = .always
        textField.isSecureTextEntry = isSecure
        textField.textContentType = .oneTimeCode
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        return textField
    }
    
    func createErrorMessageLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .red
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        validateForm() 
    }
    
    func setupUI() {
        self.title = "회원가입"
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(nickNameTF)
        contentView.addSubview(nickNameErrorMessage)
        contentView.addSubview(idLabel)
        contentView.addSubview(idTF)
        contentView.addSubview(idErrorMessage)
        contentView.addSubview(passwordLabel)
        contentView.addSubview(passwordTF)
        contentView.addSubview(passwordErrorMessage)
        contentView.addSubview(passwordCheckLabel)
        contentView.addSubview(passwordCheckTF)
        contentView.addSubview(passwordCheckErrorMessage)
        contentView.addSubview(submitButton)
        
        setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600),
            
            nickNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            nickNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nickNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            nickNameTF.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 10),
            nickNameTF.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nickNameTF.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            nickNameErrorMessage.topAnchor.constraint(equalTo: nickNameTF.bottomAnchor, constant: 5),
            nickNameErrorMessage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nickNameErrorMessage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            idLabel.topAnchor.constraint(equalTo: nickNameErrorMessage.bottomAnchor, constant: 40),
            idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            idLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            idTF.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 10),
            idTF.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            idTF.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            idErrorMessage.topAnchor.constraint(equalTo: idTF.bottomAnchor, constant: 5),
            idErrorMessage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            idErrorMessage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            passwordLabel.topAnchor.constraint(equalTo: idErrorMessage.bottomAnchor, constant: 40),
            passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            passwordTF.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordTF.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordTF.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            passwordErrorMessage.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 5),
            passwordErrorMessage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordErrorMessage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            passwordCheckLabel.topAnchor.constraint(equalTo: passwordErrorMessage.bottomAnchor, constant: 40),
            passwordCheckLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordCheckLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            passwordCheckTF.topAnchor.constraint(equalTo: passwordCheckLabel.bottomAnchor, constant: 10),
            passwordCheckTF.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordCheckTF.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            passwordCheckErrorMessage.topAnchor.constraint(equalTo: passwordCheckTF.bottomAnchor, constant: 5),
            passwordCheckErrorMessage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordCheckErrorMessage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            submitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    // TF입력
    @objc func textFieldDidChange(_ textField: UITextField) {
        validateField(textField)
    }
    
    // 유효성 검사
    func validateField(_ textField: UITextField) {
        if textField == nickNameTF {
            validateNickname()
        } else if textField == idTF {
            validateID()
        } else if textField == passwordTF {
            validatePassword()
        } else if textField == passwordCheckTF {
            validatePasswordCheck()
        }
        
        validateForm() // 전체 폼 유효성 검사 업데이트
    }
    
    func validateNickname() {
        if let nickname = nickNameTF.text, nickname.count >= 2 {
            nickNameErrorMessage.text = ""
        } else {
            nickNameErrorMessage.text = "닉네임은 2자 이상이어야 합니다."
        }
    }
    
    func validateID() {
        let idRegex = "^[a-zA-Z0-9]{6,}$"
        if let id = idTF.text, NSPredicate(format: "SELF MATCHES %@", idRegex).evaluate(with: id) {
            idErrorMessage.text = ""
        } else {
            idErrorMessage.text = "아이디는 영문 숫자 조합 6자 이상이어야 합니다."
        }
    }
    
    func validatePassword() {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+=-]).{8,}$"
        if let password = passwordTF.text, NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password) {
            passwordErrorMessage.text = ""
        } else {
            passwordErrorMessage.text = "비밀번호는 소문자, 대문자, 숫자, 특수기호 포함 8자 이상이어야 합니다."
        }
    }
    
    func validatePasswordCheck() {
        if let password = passwordTF.text, let passwordCheck = passwordCheckTF.text, password == passwordCheck {
            passwordCheckErrorMessage.text = ""
        } else {
            passwordCheckErrorMessage.text = "비밀번호가 일치하지 않습니다."
        }
    }
    
    // 유효성 검사에 따른 버튼 활성화
    func validateForm() {
        let isNicknameValid = !(nickNameTF.text?.isEmpty ?? true) && nickNameErrorMessage.text?.isEmpty == true
        let isIdValid = !(idTF.text?.isEmpty ?? true) && idErrorMessage.text?.isEmpty == true
        let isPasswordValid = !(passwordTF.text?.isEmpty ?? true) && passwordErrorMessage.text?.isEmpty == true
        let isPasswordCheckValid = !(passwordCheckTF.text?.isEmpty ?? true) && passwordCheckErrorMessage.text?.isEmpty == true
        
        let isFormValid = isNicknameValid && isIdValid && isPasswordValid && isPasswordCheckValid
        
        submitButton.isEnabled = isFormValid
        submitButton.alpha = isFormValid ? 1.0 : 0.5
    }
    
    @objc func submitButtonTapped() {
        // 가입하기 버튼 클릭 시 동작
        print("가입하기 버튼 클릭됨")
    }
}
