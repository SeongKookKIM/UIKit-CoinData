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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
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
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            })
            .catch { _ in Just([]) }
            .assign(to: &$coinData)
        
    }

    // Price _ 처리(1,000) - Model로 가야하는지..?
    func priceInt(_ price: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        return numberFormatter.string(from: NSNumber(value: price)) ?? ""
    }
}
