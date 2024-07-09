//
//  CoinService.swift
//  CoinApp
//
//  Created by SeongKook on 6/24/24.
//

import Foundation
import Combine

struct CoinService {
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
        guard let url = URL(string: "http://localhost:8080/coin/add/bookmark") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(addBookMark)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(BookmarkMessageModel.self, from: data)
        
        return result
    }
    
    // Check Bookmark
    func fetchUserBookmark(userInfo: BookmarkData) async throws -> [String] {
        guard let url = URL(string: "http://localhost:8080/coin/get/bookmark") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(userInfo)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode([String].self, from: data)
        
        return result
    }
    
    
    // Delete Bookmark
    func fetchDeleteBookmark(data: BookmarkData) async throws -> [String] {
        guard let url = URL(string: "http://localhost:8080/coin/delete/bookmark") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(data)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode([String].self, from: data)
        
        return result
    }
}
