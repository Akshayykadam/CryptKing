//
//  HomeViewModel.swift
//  CryptKing
//
//  Created by Akshay Kadam on 01/04/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{ 
    
    @Published var statistics: [StatisticModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    
    private let dataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    private let portfolioDataService = PortfolioDataService()
    
    
    init(){
        addSubscriber()
    }
    
    func addSubscriber(){
        
        // Updates allcoins
        $searchText
            .combineLatest(dataService.$allCoins)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map(filterdCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // Update portfolio
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // Update marketdata
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketCap)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        }
    
        func updatePortfolio(coin: CoinModel, amount: Double){
            portfolioDataService.updatePortfolio(coin: coin, amount: amount)
        }
    
        func reloadData(){
            isLoading = true
            dataService.getCoins()
            marketDataService.getData()
            HapticManager.notification(notificationType: .success) //for haptic on reload
        }
    }

    private func filterdCoins(text: String, coins: [CoinModel]) -> [CoinModel]{
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
                   coin.symbol.lowercased().contains(lowercasedText) ||
                   coin.id.lowercased().contains(lowercasedText)
        }
    }

private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], porfolioEntities: [PortfolioEntity]) -> [CoinModel]{
    allCoins
        .compactMap { (coin) -> CoinModel? in
            guard let entity = porfolioEntities.first(where: {$0.coinID == coin.id}) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
}
    
    private func mapGlobalMarketCap(marketDataModel: MarketDataModel? , portfolioCoins: [CoinModel]) -> [StatisticModel]{
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentage: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume", value: data.Volume)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
    
    
        let portfolioValue = portfolioCoins
                                .map({$0.currentHoldingsValue})
                                .reduce(0, +)
    
        let previousValue = 
        portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let Percentchange = coin.priceChangePercentage24H! / 100
                let previousValue = currentValue / (1 + Percentchange)
                return previousValue
            }
            .reduce(0, +)
    
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
    
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentage: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }

