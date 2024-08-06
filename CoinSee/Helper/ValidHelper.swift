//
//  ValidHelper.swift
//  CoinApp
//
//  Created by SeongKook on 7/12/24.
//

import Foundation

class ValidHelper {
    static func validateNickname(_ nickname: String) -> String? {
         if nickname.count >= 2 {
             return nil
         } else {
             return "닉네임은 2자 이상이어야 합니다."
         }
     }
     
     static func validateID(_ id: String) -> String? {
         let idRegex = "^(?=.*[a-zA-Z])(?=.*\\d)[a-zA-Z0-9]{6,}$"
         if NSPredicate(format: "SELF MATCHES %@", idRegex).evaluate(with: id) {
             return nil
         } else {
             return "아이디는 영문 숫자 조합 6자 이상이어야 합니다."
         }
     }
     
     static func validatePassword(_ password: String) -> String? {
         let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+=-]).{8,}$"
         if NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password) {
             return nil
         } else {
             return "비밀번호는 소문자, 대문자, 숫자, 특수기호 포함 8자 이상이어야 합니다."
         }
     }
     
     static func validatePasswordCheck(_ password: String, _ passwordCheck: String) -> String? {
         if password == passwordCheck {
             return nil
         } else {
             return "비밀번호가 일치하지 않습니다."
         }
     }
    
    static func validatePasswordEmpty(_ password: String) -> String? {
        if password.isEmpty {
            return "비밀번호를 입력해주세요."
        } else {
            return nil
        }
    }
}
