//
//  DetailViewModel.swift
//  CryptKing
//
//  Created by Akshay Kadam on 11/04/24.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coinDiscription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    @Published var coin: CoinModel
    private let CoinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel){
        self.coin = coin
        self.CoinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers(){
        
        CoinDetailService.$coinDetails
            .combineLatest($coin)
            .map({ (coinDetailModel, coinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) in
                
                //Overview
                let price = coinModel.currentPrice.asCurrenacyWith6Decimals()
                let priceChange = coinModel.priceChangePercentage24H
                let priceStat = StatisticModel(title: "Current Price", value: price, percentage: priceChange)
                
                let marketCap = "₹" + (coinModel.marketCap.formattedWithAbbreviations())
                let marketCapChange = coinModel.marketCapChangePercentage24H
                let MarketCapStat = StatisticModel(title: "Market Cap", value: marketCap, percentage: marketCapChange)
                
                let rank = "\(coinModel.rank)"
                let rankStat = StatisticModel(title: "Rank", value: rank)
                
                let volume = "₹" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
                let volumeStat = StatisticModel(title: "Volume", value: volume)
                
                let overviewArray: [StatisticModel] = [
                    priceStat, MarketCapStat, rankStat, volumeStat
                ]
                
                //Additional
                let high = coinModel.high24H?.asCurrenacyWith6Decimals() ?? ""
                let highStat = StatisticModel(title: "24H High", value: high)
                
                let low = coinModel.low24H?.asCurrenacyWith6Decimals() ?? ""
                let lowStat = StatisticModel(title: "24H Low", value: low)
                
                let pricechange = coinModel.priceChange24H?.asCurrenacyWith6Decimals() ?? "n/a"
                let pricePercentageChange = coinModel.priceChangePercentage24H
                let priceChangeStat = StatisticModel(title: "24H Price Change", value: pricechange, percentage: pricePercentageChange)
                
                let marketcapChange = "₹" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
                let marketCapPercentageChange = coinModel.marketCapChangePercentage24H
                let MarketCapChangeStat = StatisticModel(title: "24H Market Cap Change", value: marketcapChange, percentage: marketCapPercentageChange)
                
                let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
                let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
                let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
                
                let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
                let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
                
                let additionalArray: [StatisticModel] = [
                    highStat, lowStat, priceChangeStat, MarketCapChangeStat, blockStat, hashingStat
                ]
                
                return (overviewArray,additionalArray)
            })
            .sink { [weak self] (returnedCoinArrays) in
                self?.overviewStatistics = returnedCoinArrays.overview
                self?.additionalStatistics = returnedCoinArrays.additional
            }
            .store(in: &cancellables)
        
        CoinDetailService.$coinDetails
            .sink { [weak self] (returnedCoinDetails) in
                self!.coinDiscription = returnedCoinDetails?.readableDescription
                self!.websiteURL = returnedCoinDetails?.links?.homepage?.first
                self!.redditURL = returnedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
        
    }
    
}
