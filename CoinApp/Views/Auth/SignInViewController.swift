//
//  SignInViewController.swift
//  CoinApp
//
//  Created by SeongKook on 6/25/24.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    private let signInViewModel = SignInViewModel()
    
    // Views
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
        submitButton.addTarget(self, action: #selector(handlerSignInButton), for: .touchUpInside)
        
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
        textField.autocapitalizationType = .none
        textField.delegate = self
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
    
    // tap 제스처
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(hanlderTapGeture))
    
    // TextField 추적
    private var activeTF: UITextField?
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
        validateForm()
    }
    
    // Memory TapGestures
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.removeGestureRecognizer(tapGesture)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //setupUI
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
    
    //  setup NavigationBar
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    // setupLayout Contraint
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
        if textField == nickNameTF {
            signInViewModel.nickname = textField.text ?? ""
            nickNameErrorMessage.text = signInViewModel.nicknameErrorMessage
        } else if textField == idTF {
            signInViewModel.id = textField.text ?? ""
            idErrorMessage.text = signInViewModel.idErrorMessage
        } else if textField == passwordTF {
            signInViewModel.password = textField.text ?? ""
            passwordErrorMessage.text = signInViewModel.passwordErrorMessage
        } else if textField == passwordCheckTF {
            signInViewModel.passwordCheck = textField.text ?? ""
            passwordCheckErrorMessage.text = signInViewModel.passwordCheckErrorMessage
        }
        validateForm()
    }
    
    // 유효성 검사에 따른 버튼 활성화
    func validateForm() {
        let isFormValid = signInViewModel.isFormValid
        submitButton.isEnabled = isFormValid
        submitButton.alpha = isFormValid ? 1.0 : 0.5
    }
    
    // 가입하기 버튼
    @objc func handlerSignInButton() {
        Task {
            do {
                let result = try await signInViewModel.signIn()
                DispatchQueue.main.async {
                    if result.isSuccess {
                        self.showAlert(result.failMessage) {
                            self.navigationController?.popToRootViewController(animated: true)
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
    }
    
    // 회원가입시 알림
    func showAlert(_ message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: "회원가입", message: message, preferredStyle: .alert)
        let confirmBtn = UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        }
        alert.addAction(confirmBtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Tap Hanlder
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            if view.frame.origin.y == 0 {
                if activeTF == passwordTF {
                    view.frame.origin.y -= keyboardHeight * 0.45
                } else if activeTF == passwordCheckTF {
                    view.frame.origin.y -= keyboardHeight * 0.4
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    @objc func hanlderTapGeture(_ sender: UIView) {
        nickNameTF.resignFirstResponder()
        idTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        passwordCheckTF.resignFirstResponder()
    }
    
    // UITextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTF = textField
        

    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        activeTF = nil
        

    }
}
