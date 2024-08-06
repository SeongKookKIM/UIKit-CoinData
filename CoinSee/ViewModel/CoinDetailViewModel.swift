//
//  CoinDetailViewModel.swift
//  CoinApp
//
//  Created by SeongKook on 7/3/24.
//

import Foundation

class CoinDetailViewModel {
    private let coinService = CoinService()
    
    func addCoinBookmark(_ addBookmark: String, userId: String, userNickname: String) async throws -> BookmarkMessageModel {
        let bookmarkData: BookmarkData = BookmarkData(coinName: addBookmark, userId: userId, userNickname: userNickname)
        
        return try await coinService.fetchAddBookmark(addBookMark: bookmarkData)
    }
}
