//
//  CoinDetailModel.swift
//  CryptKing
//
//  Created by Akshay Kadam on 11/04/24.
//

import Foundation

/*
 
 import Foundation

 let headers = [
   "accept": "application/json",
   "x-cg-demo-api-key": "CG-uMqq8fbojWt9iKUv8QekShGd"
 ]

 let request = NSMutableURLRequest(url: NSURL(string: "https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")! as URL,
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


struct CoinDetailModel: Codable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let description: Description?
    let links: Links?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, description, links
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
    }
    
    var readableDescription: String? {
        return description?.en?.removingHTMLOccurances
    }
}

struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?
    
    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditURL = "subreddit_url"
    }
}

struct Description: Codable {
    let en: String?
}
