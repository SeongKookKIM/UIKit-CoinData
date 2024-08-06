//
//  ServiceHelper.swift
//  CoinApp
//
//  Created by SeongKook on 7/10/24.
//

import Foundation

class ServiceHelper {
    
    func createRequest(urlString: String, method: String, body: Data? = nil) throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        return request
    }

    func sendRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(T.self, from: data)
        return result
    }
}
