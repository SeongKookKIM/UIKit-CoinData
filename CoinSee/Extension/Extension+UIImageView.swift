//
//  Extension+UIImageView.swift
//  CoinApp
//
//  Created by SeongKook on 7/12/24.
//

import UIKit

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
