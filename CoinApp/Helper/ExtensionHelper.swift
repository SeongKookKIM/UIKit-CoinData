//
//  ExtensionHelper.swift
//  CoinApp
//
//  Created by SeongKook on 6/24/24.
//

import Foundation
import UIKit

// Double -> String으로 변환 (ex: 1000 -> 1,000)
extension Double {
    func priceInt() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

// UIImage exchange tintColor
extension UIImage {
    func withTintColor(_ color: UIColor) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: self.size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: self.size))
            self.draw(at: .zero, blendMode: .destinationIn, alpha: 1.0)
        }
    }
}
