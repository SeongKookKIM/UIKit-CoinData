//
//  ViewHelper.swift
//  CoinApp
//
//  Created by SeongKook on 7/10/24.
//

import Foundation
import UIKit

// UILabel
extension UILabel {
    static func basicLabel(fontSize: CGFloat, fontWeight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createLabel(fontSize: CGFloat, fontWeight: UIFont.Weight, textColor: UIColor, text: String, align: NSTextAlignment) -> UILabel {
        let loginTitleLabel = UILabel()
        loginTitleLabel.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        loginTitleLabel.textColor = textColor
        loginTitleLabel.text = text
        loginTitleLabel.textAlignment = align
        loginTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return loginTitleLabel
    }
}

// UIImage
extension UIImageView {
    static func bookmarkImage(imageName: String) -> UIImageView {
        let image = UIImageView(image: UIImage(systemName: imageName))
        image.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        image.tintColor = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }
}

// UITextField
extension UITextField {
    static func createTextField(fontSize: CGFloat, placeholder: String, placeholderFontSize: CGFloat, isSecure: Bool) -> UITextField {
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
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}

// UIButton
extension UIButton {
    static func createButton(title: String, backgroundColor: UIColor, foregroundColor: UIColor) -> UIButton {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = foregroundColor
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
        
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
}
