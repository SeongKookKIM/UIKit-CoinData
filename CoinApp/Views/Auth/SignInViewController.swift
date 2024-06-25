//
//  SignInViewController.swift
//  CoinApp
//
//  Created by SeongKook on 6/25/24.
//

import UIKit

class SignInViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.rowHeight = 80
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    let nickNameTF = UITextField()
    let nickNameWarningLabel = UILabel()
    
    let idTF = UITextField()
    let idWarningLabel = UILabel()
    
    let passwordTF = UITextField()
    let passwordWarningLabel = UILabel()
    
    let passwordConfirmTF = UITextField()
    let passwordConfirmWarningLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "회원가입"
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() } // 기존 서브뷰 제거
        
        switch indexPath.row {
        case 0:
            setupTextField(cell.contentView, textField: nickNameTF, placeholder: "닉네임")
        case 1:
            setupWarningLabel(cell.contentView, warningLabel: nickNameWarningLabel)
        case 2:
            setupTextField(cell.contentView, textField: idTF, placeholder: "아이디 (영문 숫자 조합 6자 이상)")
        case 3:
            setupWarningLabel(cell.contentView, warningLabel: idWarningLabel)
        case 4:
            setupTextField(cell.contentView, textField: passwordTF, placeholder: "비밀번호 (영어 소문자, 대문자, 특수기호 포함 8자 이상)")
            passwordTF.isSecureTextEntry = true
        case 5:
            setupWarningLabel(cell.contentView, warningLabel: passwordWarningLabel)
        case 6:
            setupTextField(cell.contentView, textField: passwordConfirmTF, placeholder: "비밀번호 확인")
            passwordConfirmTF.isSecureTextEntry = true
        case 7:
            setupWarningLabel(cell.contentView, warningLabel: passwordConfirmWarningLabel)
        default:
            break
        }
        
        return cell
    }
    
    func setupTextField(_ view: UIView, textField: UITextField, placeholder: String) {
        textField.borderStyle = .roundedRect
        textField.placeholder = placeholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupWarningLabel(_ view: UIView, warningLabel: UILabel) {
        warningLabel.font = UIFont.systemFont(ofSize: 12)
        warningLabel.textColor = .red
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(warningLabel)
        
        NSLayoutConstraint.activate([
            warningLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateTextField(textField)
    }
    
    func validateTextField(_ textField: UITextField) {
        if textField == nickNameTF {
            if let text = textField.text, text.count >= 2 {
                nickNameWarningLabel.text = ""
            } else {
                nickNameWarningLabel.text = "닉네임은 두 글자 이상이어야 합니다."
            }
        } else if textField == idTF {
            if let text = textField.text, isValidID(text) {
                idWarningLabel.text = ""
            } else {
                idWarningLabel.text = "아이디는 영문 숫자 조합 6자 이상이어야 합니다."
            }
        } else if textField == passwordTF {
            if let text = textField.text, isValidPassword(text) {
                passwordWarningLabel.text = ""
            } else {
                passwordWarningLabel.text = "비밀번호는 소문자, 대문자, 특수기호 포함 8자 이상이어야 합니다."
            }
        } else if textField == passwordConfirmTF {
            if let text = textField.text, text == passwordTF.text {
                passwordConfirmWarningLabel.text = ""
            } else {
                passwordConfirmWarningLabel.text = "비밀번호가 일치하지 않습니다."
            }
        }
    }
    
    func isValidID(_ id: String) -> Bool {
        let idRegEx = "^[a-zA-Z0-9]{6,}$"
        let idTest = NSPredicate(format:"SELF MATCHES %@", idRegEx)
        return idTest.evaluate(with: id)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\W).{8,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
}
