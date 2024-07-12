//
//  Extension+UIImage.swift
//  CoinApp
//
//  Created by SeongKook on 7/12/24.
//

import UIKit

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
