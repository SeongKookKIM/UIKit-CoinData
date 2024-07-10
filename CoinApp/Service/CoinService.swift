//
//  CoinService.swift
//  CoinApp
//
//  Created by SeongKook on 6/24/24.
//

import Foundation
import Combine

struct CoinService {
    
    private let serviceHelper = ServiceHelper()
    
    private let baseURL = "https://api.coinpaprika.com/v1/tickers?quotes=KRW"
    
    func fetchCoinData() -> AnyPublisher<[CoinModel], Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let request = URLRequest(url: url)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error -> Error in
                return APIError.transportError(error)
            }
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                guard let urlResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                if (200..<300) ~= urlResponse.statusCode { }
                else {
                    let decoder = JSONDecoder()
                    let apiError = try decoder.decode(APIErrorMessage.self, from: data)
                    
                    if urlResponse.statusCode == 400 {
                        throw APIError.validationError(apiError.reason)
                    }
                }
                return (data, response)
            }
        
            .map(\.data)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchAddBookmark(addBookMark: BookmarkData) async throws -> BookmarkMessageModel {
        let body = try JSONEncoder().encode(addBookMark)
        let request = try serviceHelper.createRequest(urlString: "http://localhost:8080/coin/add/bookmark", method: "POST", body: body)
        return try await serviceHelper.sendRequest(request)
    }
    
    // Check Bookmark
    func fetchUserBookmark(userInfo: BookmarkData) async throws -> [String] {
        let body = try JSONEncoder().encode(userInfo)
        let request = try serviceHelper.createRequest(urlString: "http://localhost:8080/coin/get/bookmark", method: "POST", body: body)
        return try await serviceHelper.sendRequest(request)
    }
    
    
    // Delete Bookmark
    func fetchDeleteBookmark(data: BookmarkData) async throws -> [String] {
        let body = try JSONEncoder().encode(data)
        let request = try serviceHelper.createRequest(urlString: "http://localhost:8080/coin/delete/bookmark", method: "POST", body: body)
        return try await serviceHelper.sendRequest(request)
    }
}
