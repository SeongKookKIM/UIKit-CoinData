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
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        label.textColor = textColor
        label.text = text
        label.textAlignment = align
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    static func errorLabel(fontSize: CGFloat, textColor: UIColor, text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = textColor
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}
