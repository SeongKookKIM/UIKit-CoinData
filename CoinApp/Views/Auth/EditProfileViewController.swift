//
//  EditProfileViewController.swift
//  CoinApp
//
//  Created by SeongKook on 7/15/24.
//

import UIKit
import Combine

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    
    private let editProfileViewModel = EditProfileViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    // 닉네임
    private let nickNameLabel: UILabel = UILabel.createLabel(fontSize: 16, fontWeight: .bold, textColor: .gray, text: "닉네임", align: .left)
    private let nickNameTF: UITextField = UITextField.createTextField(fontSize: 16, placeholder: "2자이상 입력해주세요.", placeholderFontSize: 14, isSecure: false, testIdentifiler: "editNickname")
    private let nickNameErrorMessage: UILabel = UILabel.errorLabel(fontSize: 12, textColor: .red, text: "")
    
    // 아이디
    private let idLabel: UILabel = UILabel.createLabel(fontSize: 16, fontWeight: .bold, textColor: .gray, text: "아이디", align: .left)
    private let idTF: UITextField = UITextField.createTextField(fontSize: 16, placeholder: "영문 숫자 조합 6자 이상.", placeholderFontSize: 14, isSecure: false, testIdentifiler: "editID")
    private let idErrorMessage: UILabel = UILabel.errorLabel(fontSize: 12, textColor: .red, text: "")
    
    // 기존 비밀번호
    private let passwordLabel: UILabel = UILabel.createLabel(fontSize: 16, fontWeight: .bold, textColor: .gray, text: "기존 비밀번호", align: .left)
    private let passwordTF: UITextField = UITextField.createTextField(fontSize: 16, placeholder: "기존 비밀번호를 입력해주세요.", placeholderFontSize: 14, isSecure: true, testIdentifiler: "editPW")
    private let passwordErrorMessage: UILabel = UILabel.errorLabel(fontSize: 12, textColor: .red, text: "")
    
    // 새로운 비밀번호
    private let newPasswordLabel: UILabel = UILabel.createLabel(fontSize: 16, fontWeight: .bold, textColor: .gray, text: "새로운 비밀번호", align: .left)
    private let newPasswordTF: UITextField = UITextField.createTextField(fontSize: 16, placeholder: "영어 소문자, 대문자, 특수기호 포함 8자 이상.", placeholderFontSize: 14, isSecure: true, testIdentifiler: "editNewPW")
    private let newPasswordErrorMessage: UILabel = UILabel.errorLabel(fontSize: 12, textColor: .red, text: "")
    
    // 새로운 비밀번호 확인
    private let newPasswordCheckLabel: UILabel = UILabel.createLabel(fontSize: 16, fontWeight: .bold, textColor: .gray, text: "비밀번호 확인", align: .left)
    private let newPasswordCheckTF: UITextField = UITextField.createTextField(fontSize: 16, placeholder: "비밀번호를 다시 입력해주세요.", placeholderFontSize: 14, isSecure: true, testIdentifiler: "editNewPWCheck")
    private let newPasswordCheckErrorMessage: UILabel = UILabel.errorLabel(fontSize: 12, textColor: .red, text: "")
    
    // 회원정보 수정 Btn
    private let editProfileBtn: UIButton = {
        UIButton.submitButton(title: "수정하기", backgroundColor: .systemBlue, foregroundColor: .white, testIdentifiler: "editSubmitBtn")
    }()
    
    // tap 제스처
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(hanlderTapGeture))
    
    // TextField 추적
    private var activeTF: UITextField?
    
    
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
        setupBindData()
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
    
    
    // setupUI
    private func setupUI() {
        self.title = "회원정보 수정"
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
        self.view.addSubview(newPasswordLabel)
        self.view.addSubview(newPasswordTF)
        self.view.addSubview(newPasswordErrorMessage)
        self.view.addSubview(newPasswordCheckLabel)
        self.view.addSubview(newPasswordCheckTF)
        self.view.addSubview(newPasswordCheckErrorMessage)
        self.view.addSubview(editProfileBtn)
        
        passwordTF.textContentType = .newPassword
        newPasswordTF.textContentType = .newPassword
        newPasswordCheckTF.textContentType = .newPassword
        
        setupLayout()
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
            
            newPasswordLabel.topAnchor.constraint(equalTo: passwordErrorMessage.bottomAnchor, constant: 40),
            newPasswordLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            newPasswordLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            newPasswordTF.topAnchor.constraint(equalTo: newPasswordLabel.bottomAnchor, constant: 10),
            newPasswordTF.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            newPasswordTF.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            newPasswordErrorMessage.topAnchor.constraint(equalTo: newPasswordTF.bottomAnchor, constant: 5),
            newPasswordErrorMessage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            newPasswordErrorMessage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            newPasswordCheckLabel.topAnchor.constraint(equalTo: newPasswordErrorMessage.bottomAnchor, constant: 40),
            newPasswordCheckLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            newPasswordCheckLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            newPasswordCheckTF.topAnchor.constraint(equalTo: newPasswordCheckLabel.bottomAnchor, constant: 10),
            newPasswordCheckTF.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            newPasswordCheckTF.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            newPasswordCheckErrorMessage.topAnchor.constraint(equalTo: newPasswordCheckTF.bottomAnchor, constant: 5),
            newPasswordCheckErrorMessage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            newPasswordCheckErrorMessage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            editProfileBtn.topAnchor.constraint(equalTo: newPasswordCheckErrorMessage.bottomAnchor, constant: 30),
            editProfileBtn.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            editProfileBtn.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20)
        ])
    }
    
    // Data Binding
    private func setupBindData() {
        nickNameTF.text = editProfileViewModel.nickname
        idTF.text = editProfileViewModel.id
    }
    
    // Action
    private func setupActions() {
        let textFields = [nickNameTF, idTF, passwordTF,  newPasswordTF, newPasswordCheckTF]
        
        for textFiled in textFields {
            textFiled.delegate = self
            textFiled.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        editProfileBtn.addTarget(self, action: #selector(handlerEditProfileButton), for: .touchUpInside)
    }
    
    // TF입력
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == nickNameTF {
            editProfileViewModel.nickname = textField.text ?? ""
            nickNameErrorMessage.text = editProfileViewModel.nicknameErrorMessage
        } else if textField == idTF {
            editProfileViewModel.id = textField.text ?? ""
            idErrorMessage.text = editProfileViewModel.idErrorMessage
        } else if textField == passwordTF {
            editProfileViewModel.password = textField.text ?? ""
            passwordErrorMessage.text = editProfileViewModel.passwordErrorMessage
        } else if textField == newPasswordTF {
            editProfileViewModel.newPassword = textField.text ?? ""
            newPasswordErrorMessage.text = editProfileViewModel.newPasswordErrorMessage
        } else if textField == newPasswordCheckTF {
            editProfileViewModel.newPasswordCheck = textField.text ?? ""
            newPasswordCheckErrorMessage.text = editProfileViewModel.newPasswordCheckErrorMessage
        }
        validateForm()
    }
    
    // 유효성 검사에 따른 버튼 활성화
    private func validateForm() {
        let isFormValid = editProfileViewModel.isFormValid
        
        editProfileBtn.isEnabled = isFormValid
        editProfileBtn.alpha = isFormValid ? 1.0 : 0.5
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
    
    // EditProfileBtn
    @objc func handlerEditProfileButton() {
        Task {
            do {
                let result = try await editProfileViewModel.editProfile(defaultUserId: UserViewModel.shared.userInfo?.id ?? "", defaultUserNickname: UserViewModel.shared.userInfo?.nickName ?? "")
                DispatchQueue.main.async {
                    if result.isSuccess {
                        self.showAlert(result.failMessage) {
                             UserViewModel.shared.fetchUserInfo()
                             self.navigationController?.popToRootViewController(animated: true)
                        }
                    } else {
                        self.showAlert(result.failMessage, completion: nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("에러 발생: \(error)")
                    self.showAlert("회원정보 수정 중 오류가 발생했습니다.", completion: nil)
                }
            }
        }
    }
    
    // 회원가입시 알림
    private func showAlert(_ message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: "회원정보 수정", message: message, preferredStyle: .alert)
        let confirmBtn = UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        }
        alert.addAction(confirmBtn)
        alert.view.accessibilityIdentifier = "editProfileAlert"
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Tap Hanlder
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            if view.frame.origin.y == 0 {
                if activeTF == newPasswordTF {
                    view.frame.origin.y -= keyboardHeight * 0.65
                } else if activeTF == newPasswordCheckTF {
                    view.frame.origin.y -= keyboardHeight * 0.6
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
        newPasswordTF.resignFirstResponder()
        newPasswordCheckTF.resignFirstResponder()
    }
    
    // UITextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTF = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        activeTF = nil
    }
    
}
