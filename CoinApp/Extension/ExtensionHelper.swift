//
//  ExtensionHelper.swift
//  CoinApp
//
//  Created by SeongKook on 6/24/24.
//

import Foundation

extension Double {
    func priceInt() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
