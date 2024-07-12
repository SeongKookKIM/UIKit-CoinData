//
//  Extension+UILabel.swift
//  CoinApp
//
//  Created by SeongKook on 7/12/24.
//

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
