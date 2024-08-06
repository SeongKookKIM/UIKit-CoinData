//
//  KeyChainHelper.swift
//  CoinApp
//
//  Created by SeongKook on 6/27/24.
//

import Foundation
import Security

class KeychainHelper {

    func save(_ value: String, forKey key: String) {
        guard let data = value.data(using: .utf8) else { return }

        // 기존 항목 삭제
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as NSDictionary
        SecItemDelete(query)

        // 새로운 항목 추가
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as NSDictionary

        SecItemAdd(attributes, nil)
    }

    func get(_ key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ] as NSDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }

    func delete(_ key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as NSDictionary
        SecItemDelete(query)
    }
}
