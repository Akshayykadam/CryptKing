//
//  MarketDataModel.swift
//  CryptKing
//
//  Created by Akshay Kadam on 04/04/24.
//

import Foundation


/*
 import Foundation

 let headers = ["x-cg-demo-api-key": "CG-uMqq8fbojWt9iKUv8QekShGd"]

 let request = NSMutableURLRequest(url: NSURL(string: "https://api.coingecko.com/api/v3/global")! as URL,
                                         cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 10.0)
 request.httpMethod = "GET"
 request.allHTTPHeaderFields = headers

 let session = URLSession.shared
 let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
   if (error != nil) {
     print(error as Any)
   } else {
     let httpResponse = response as? HTTPURLResponse
     print(httpResponse)
   }
 })

 dataTask.resume()
 */

struct GlobalMarketCap: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String{
        if let item = totalMarketCap.first(where: { $0.key == "inr"}){
            return "₹ " + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var Volume: String{
        if let item = totalVolume.first(where: {$0.key == "inr"}){
            return "₹ " + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance: String{
        if let item = marketCapPercentage.first(where: { $0.key == "btc"}){
            return item.value.asPercentString()
        }
        return ""
    }
}

