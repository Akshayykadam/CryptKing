//
//  MarketDataService.swift
//  CryptKing
//
//  Created by Akshay Kadam on 04/04/24.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    var MarketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {
            return
        }
        
        MarketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalMarketCap.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handelComplition, receiveValue: { [weak self] returnedGlobalData in
                self?.marketData = returnedGlobalData.data
                self?.MarketDataSubscription?.cancel()
            })
    }
}
