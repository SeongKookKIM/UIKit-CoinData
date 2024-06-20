//
//  WebSocketService.swift
//  CoinApp
//
//  Created by SeongKook on 6/20/24.
//

import Foundation
import Combine

class WebSocketService {
    private var webSocketTask: URLSessionWebSocketTask?
    
    var coinDataPublisher = PassthroughSubject<[CoinModel], Never>()
    
    init() {
        connect()
    }
    
    func connect() {
        let url = URL(string: "https://api.coinpaprika.com/v1/tickers?quotes=KRW")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        
        receiveMessages()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    private func receiveMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error in receiving message: \(error)")
            case .success(let message):
                switch message {
                case .data(let data):
                    self?.handleData(data)
                case .string(let text):
                    if let data = text.data(using: .utf8) {
                        self?.handleData(data)
                    }
                @unknown default:
                    fatalError()
                }
                self?.receiveMessages() // Continue receiving messages
            }
        }
    }
    
    private func handleData(_ data: Data) {
        do {
            let coinData = try JSONDecoder().decode([CoinModel].self, from: data)
            DispatchQueue.main.async {
                self.coinDataPublisher.send(coinData)
            }
        } catch {
            print("Failed to decode data: \(error)")
        }
    }
}

