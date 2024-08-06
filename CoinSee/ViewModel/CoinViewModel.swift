//
//  CoinViewModel.swift
//  CoinApp
//
//  Created by SeongKook on 6/17/24.
//

import Foundation
import Combine

class CoinViewModel: ObservableObject {
    @Published var coinData: [CoinModel] = []
    @Published var filteredCoinData: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var bookmarkList: [String] = []
    @Published var bookmarkedCoinData: [CoinModel] = []
    
    private var coinService = CoinService()
    private var cancellable = Set<AnyCancellable>()
    
    
    
    // ViewModel 초기화
    init() {
        fetchCoinData()
    }
    
    // 데이터 패칭
    func fetchCoinData() {
        isLoading = true
        
        coinService.fetchCoinData()
            .receive(on: RunLoop.main)
            .handleEvents(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("\(error.localizedDescription)")
                    self?.errorMessage = "데이터를 불러올 수 없습니다."
                }
            })
            .catch { _ in Just([]) }
            .assign(to: &$coinData)
        
    }
    
    // Search Data
    func searchCoinData(with query: String) {
        if query.isEmpty {
            return filteredCoinData = coinData
        } else {
            filteredCoinData = coinData.filter { coin in
                return coin.name.localizedCaseInsensitiveContains(query) ||
                       coin.symbol.localizedCaseInsensitiveContains(query) ||
                       String(format: "%.2f", coin.quotes.krw.price).localizedCaseInsensitiveContains(query)
            }
        }
    }
    
    // DataUpdate
    func updateCoinData() {
        fetchCoinData()
    }
    
    // Fetch Bookmark
    func fetchCheckBookmark(userId: String, userNickname: String) async throws -> [String] {
        let finduser = BookmarkData(coinName: nil, userId: userId, userNickname: userNickname)
        let result =  try await coinService.fetchUserBookmark(userInfo: finduser)
        bookmarkList = result
        
        return result
    }
    
    // Filter Bookmark CoinData
    func filterBookmarkedCoinData() {
        bookmarkedCoinData = coinData.filter { bookmarkList.contains($0.name) }
    }
    
    // Delete Bookmark CoinData
    func deleteBookmarkedCoinData(userId: String, userNickname: String, coinName: String) async throws {
        let deleteData = BookmarkData(coinName: coinName, userId: userId, userNickname: userNickname)
        let result = try await coinService.fetchDeleteBookmark(data: deleteData)
        
        bookmarkList = result
        filterBookmarkedCoinData()
    }
}
