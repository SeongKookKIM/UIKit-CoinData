//
//  SignInViewController.swift
//  CoinApp
//
//  Created by SeongKook on 6/25/24.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    private let signUpViewModel = SignUpViewModel()
        
    // 닉네임
    private let nickNameLabel: UILabel = UILabel.createLabel(fontSize: 16, fontWeight: .bold, textColor: .gray, text: "닉네임", align: .left)
    private let nickNameTF: UITextField = UITextField.createTextField(fontSize: 16, placeholder: "2자이상 입력해주세요.", placeholderFontSize: 14, isSecure: false, testIdentifiler: "signUpNickname")
    private let nickNameErrorMessage: UILabel = UILabel.errorLabel(fontSize: 12, textColor: .red, text: "")
    
    // 아이디
    private let idLabel: UILabel = UILabel.createLabel(fontSize: 16, fontWeight: .bold, textColor: .gray, text: "아이디", align: .left)
    private let idTF: UITextField = UITextField.createTextField(fontSize: 16, placeholder: "영문 숫자 조합 6자 이상.", placeholderFontSize: 14, isSecure: false, testIdentifiler: "signUpID")
    private let idErrorMessage: UILabel = UILabel.errorLabel(fontSize: 12, textColor: .red, text: "")
    
    // 비밀번호
    private let passwordLabel: UILabel = UILabel.createLabel(fontSize: 16, fontWeight: .bold, textColor: .gray, text: "비밀번호", align: .left)
    private let passwordTF: UITextField = UITextField.createTextField(fontSize: 16, placeholder: "영어 소문자, 대문자, 특수기호 포함 8자 이상.", placeholderFontSize: 14, isSecure: true, testIdentifiler: "signUpPW")
    private let passwordErrorMessage: UILabel = UILabel.errorLabel(fontSize: 12, textColor: .red, text: "")
    
    // 비밀번호 확인
    private let passwordCheckLabel: UILabel = UILabel.createLabel(fontSize: 16, fontWeight: .bold, textColor: .gray, text: "비밀번호 확인", align: .left)
    private let passwordCheckTF: UITextField = UITextField.createTextField(fontSize: 16, placeholder: "비밀번호를 다시 입력해주세요.", placeholderFontSize: 14, isSecure: true, testIdentifiler: "signUpPWCheck")
    private let passwordCheckErrorMessage: UILabel = UILabel.errorLabel(fontSize: 12, textColor: .red, text: "")
    
    // Submit Btn
    private let submitButton: UIButton = {
        UIButton.submitButton(title: "가입하기", backgroundColor: .systemBlue, foregroundColor: .white, testIdentifiler: "signUpSubmitBtn")
    }()
    
    
    // tap 제스처
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(hanlderTapGeture))
    
    // TextField 추적
    private var activeTF: UITextField?
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
        setupActions()
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
    private func setupUI() {
        self.title = "회원가입"
        self.view.backgroundColor = .white

        
        self.view.addSubview(nickNameLabel)
        self.view.addSubview(nickNameTF)
        self.view.addSubview(nickNameErrorMessage)
        self.view.addSubview(idLabel)
        self.view.addSubview(idTF)
        self.view.addSubview(idErrorMessage)
        self.view.addSubview(passwordLabel)
        self.view.addSubview(passwordTF)
        self.view.addSubview(passwordErrorMessage)
        self.view.addSubview(passwordCheckLabel)
        self.view.addSubview(passwordCheckTF)
        self.view.addSubview(passwordCheckErrorMessage)
        self.view.addSubview(submitButton)
        
        setupLayout()
    }
    
    // Action
    private func setupActions() {
        let textFields = [nickNameTF, idTF, passwordTF, passwordCheckTF]
        
        for textFiled in textFields {
            textFiled.delegate = self
            textFiled.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        submitButton.addTarget(self, action: #selector(handlerSignUpButton), for: .touchUpInside)
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
    private func setupLayout() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            nickNameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            nickNameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            nickNameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            nickNameTF.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 10),
            nickNameTF.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            nickNameTF.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            nickNameErrorMessage.topAnchor.constraint(equalTo: nickNameTF.bottomAnchor, constant: 5),
            nickNameErrorMessage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            nickNameErrorMessage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            idLabel.topAnchor.constraint(equalTo: nickNameErrorMessage.bottomAnchor, constant: 40),
            idLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            idLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            idTF.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 10),
            idTF.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            idTF.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            idErrorMessage.topAnchor.constraint(equalTo: idTF.bottomAnchor, constant: 5),
            idErrorMessage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            idErrorMessage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            passwordLabel.topAnchor.constraint(equalTo: idErrorMessage.bottomAnchor, constant: 40),
            passwordLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            passwordLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            passwordTF.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordTF.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            passwordTF.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            passwordErrorMessage.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 5),
            passwordErrorMessage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            passwordErrorMessage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            passwordCheckLabel.topAnchor.constraint(equalTo: passwordErrorMessage.bottomAnchor, constant: 40),
            passwordCheckLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            passwordCheckLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            passwordCheckTF.topAnchor.constraint(equalTo: passwordCheckLabel.bottomAnchor, constant: 10),
            passwordCheckTF.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            passwordCheckTF.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            passwordCheckErrorMessage.topAnchor.constraint(equalTo: passwordCheckTF.bottomAnchor, constant: 5),
            passwordCheckErrorMessage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            passwordCheckErrorMessage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
   
            submitButton.topAnchor.constraint(equalTo: passwordCheckErrorMessage.bottomAnchor, constant: 30),
            submitButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20)
        ])
    }
    
    // TF입력
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == nickNameTF {
            signUpViewModel.nickname = textField.text ?? ""
            nickNameErrorMessage.text = signUpViewModel.nicknameErrorMessage
        } else if textField == idTF {
            signUpViewModel.id = textField.text ?? ""
            idErrorMessage.text = signUpViewModel.idErrorMessage
        } else if textField == passwordTF {
            signUpViewModel.password = textField.text ?? ""
            passwordErrorMessage.text = signUpViewModel.passwordErrorMessage
        } else if textField == passwordCheckTF {
            signUpViewModel.passwordCheck = textField.text ?? ""
            passwordCheckErrorMessage.text = signUpViewModel.passwordCheckErrorMessage
        }
        validateForm()
    }
    
    // 유효성 검사에 따른 버튼 활성화
    private func validateForm() {
        let isFormValid = signUpViewModel.isFormValid
        submitButton.isEnabled = isFormValid
        submitButton.alpha = isFormValid ? 1.0 : 0.5
    }
    
    // 가입하기 버튼
    @objc func handlerSignUpButton() {
        Task {
            do {
                let result = try await signUpViewModel.signUp()
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
    private func showAlert(_ message: String, completion: (() -> Void)?) {
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
                    view.frame.origin.y -= keyboardHeight * 0.35
                } else if activeTF == passwordCheckTF {
                    view.frame.origin.y -= keyboardHeight * 0.3
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
