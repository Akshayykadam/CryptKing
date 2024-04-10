//
//  CoinDataService.swift
//  CryptKing
//
//  Created by Akshay Kadam on 02/04/24.
//

import Foundation
import Combine


//class CoinDataService{
//    
//    @Published var allCoins: [CoinModel] = []
//    var coinSubscription: AnyCancellable?
//    init(){
//        getCoins()
//    }
//    
//    private func getCoins() {
//        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=inr&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=24h") else {
//            return
//        }
//        
//        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
//            .subscribe(on: DispatchQueue.global(qos: .default))
//            .tryMap { (output) -> Data in
//                guard let response = output.response as? HTTPURLResponse,
//                      response.statusCode >= 200 && response.statusCode < 300 else {
//                    throw URLError(.badServerResponse)
//                }
//                return output.data
//            }
//            .decode(type: [CoinModel].self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print(error)
//                }
//            }, receiveValue: { [weak self] returnedCoins in
//                self?.allCoins = returnedCoins
//            })
//    }
//
//}


 class CoinDataService {
     
     @Published var allCoins: [CoinModel] = []
     var coinSubscription: AnyCancellable?
     
     init() {
         getCoins()
     }
     
    func getCoins() {
         guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=inr&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=1h") else {
             return
         }
         
         coinSubscription = NetworkingManager.download(url: url)
             .decode(type: [CoinModel].self, decoder: JSONDecoder())
             .sink(receiveCompletion: NetworkingManager.handelComplition, receiveValue: { [weak self] returnedCoins in
                 print("Decoded coins data: \(returnedCoins)")
                 self?.allCoins = returnedCoins
                 self?.coinSubscription?.cancel()
             })
     }
 }
