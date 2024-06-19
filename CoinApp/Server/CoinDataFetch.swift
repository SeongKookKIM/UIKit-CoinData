//
//  CoinDataFetch.swift
//  CoinApp
//
//  Created by SeongKook on 6/17/24.
//

/*
 import Foundation
 import Combine

 class CoinDataFetch {
     func fetchActorData() -> AnyPublisher<[CoinModel], Error> {
         guard let url = URL(string: "https://socrates-api.vercel.app/socrates") else {
             return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
         }
         return URLSession.shared.dataTaskPublisher(for: url)
             .map(\.data)
             .decode(type: [CoinModel].self, decoder: JSONDecoder())
             .eraseToAnyPublisher()
     }
 }
 */

