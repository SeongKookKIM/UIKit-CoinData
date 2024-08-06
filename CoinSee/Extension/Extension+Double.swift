//
//  Extension+Double.swift
//  CoinApp
//
//  Created by SeongKook on 7/12/24.
//

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
