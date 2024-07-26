//
//  Extension+UITextField.swift
//  CoinApp
//
//  Created by SeongKook on 7/12/24.
//

import UIKit

// UITextField
extension UITextField {
    static func createTextField(fontSize: CGFloat, placeholder: String, placeholderFontSize: CGFloat, isSecure: Bool, testIdentifiler: String) -> UITextField {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: fontSize)
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: placeholderFontSize, weight: .regular)]
        )
        textField.borderStyle = .roundedRect
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 6.0, height: 0.0))
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = isSecure
        textField.accessibilityIdentifier = testIdentifiler
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
