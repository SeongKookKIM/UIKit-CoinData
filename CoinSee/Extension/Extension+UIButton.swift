//
//  Extension+UIButton.swift
//  CoinApp
//
//  Created by SeongKook on 7/12/24.
//

import UIKit

// UIButton
extension UIButton {
    static func createButton(title: String, backgroundColor: UIColor, foregroundColor: UIColor, testIdentifiler: String) -> UIButton {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = foregroundColor
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
        
        button.configuration = config
        button.accessibilityIdentifier = testIdentifiler
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    static func submitButton(title: String, backgroundColor: UIColor, foregroundColor: UIColor, testIdentifiler: String) -> UIButton {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = foregroundColor
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
        
        button.configuration = config
        button.isEnabled = false
        button.alpha = 0.5
        
        button.accessibilityIdentifier = testIdentifiler
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
}
