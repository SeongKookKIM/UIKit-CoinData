//
//  CoinViewModel.swift
//  CoinApp
//
//  Created by SeongKook on 6/17/24.
//

import Foundation
import Combine

//struct APIErrorMessage: Decodable {
//  var error: Bool
//  var reason: String
//}
//
//enum APIError: LocalizedError {
//    case transportError(Error)
//    case invalidResponse
//    case validationError(String)
//    case serverError(statusCode: Int, reason: String? = nil, retryAfter: String? = nil)
//}

class CoinViewModel: ObservableObject {
    @Published var coinData: [CoinModel] = []
    @Published var isLoading: Bool = false
    
    var cancellable = Set<AnyCancellable>()
    
    // ViewModel 초기화
    init() {
        fetchCoinData()
    }
    
    // 데이터 패칭 - assign로 수정
    func fetchCoinData() {
        guard let url = URL(string: "https://api.coinpaprika.com/v1/tickers?quotes=KRW") else {
            return
        }
        isLoading = true
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .catch { _ in Just([]) }
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            })
            .assign(to: \.coinData, on: self)
            .store(in: &cancellable)
//            .mapError { error -> Error in
//                return APIError.transportError(error) // 연결에러
//            }
//            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
//    
//                guard let urlResponse = response as? HTTPURLResponse else {
//                    throw APIError.invalidResponse
//                }
//                if (200..<300) ~= urlResponse.statusCode { } else {
//                    let decoder = JSONDecoder()
//                    let apiError = try decoder.decode(APIErrorMessage.self, from: data)
//                    
//                    if urlResponse.statusCode == 400 {
//                        print("\(apiError.reason)")
//                    }
//                    
//                    if (500..<600) ~= urlResponse.statusCode {
//                        print("서버 오류")
//                    }
//                }
//                return (data, response)
//            }

        
        /*
         URLSession.shared.dataTaskPublisher(for: url)
             .map(\.data)
             .decode(type: [CoinModel].self, decoder: JSONDecoder())
             .receive(on: DispatchQueue.main)
             .sink(receiveCompletion: { [weak self] completion in
                 switch completion {
                 case .finished:
                     break
                 case .failure(let error):
                     print("패칭 에러: \(error.localizedDescription)")
                 }
             }, receiveValue: { [weak self] data in
                 self?.coinData = data
             })
             .store(in: &cancellables)
         */
    }
    
    // Price _ 처리(1,000) - Model로 가야하는지..?
    func priceInt(_ price: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        return numberFormatter.string(from: NSNumber(value: price)) ?? ""
    }
}




