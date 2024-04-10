//
//  NetworkingManager.swift
//  CryptKing
//
//  Created by Akshay Kadam on 03/04/24.
//

import Foundation
import Combine

class NetworkingManager{
    
    enum NetworkingError: LocalizedError{
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String?{
            switch self{
            case .badURLResponse(url: let url): return "[⚠️] Bad response from URL: \(url)"
            case .unknown: return "[⚠️] Unknow error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("CG-uMqq8fbojWt9iKUv8QekShGd", forHTTPHeaderField: "x-cg-demo-api-key")
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .default))
                .tryMap({try handelURLResponse(output: $0, url: url)})
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    
    static func downloadImage(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({try handelURLResponse(output: $0, url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    
    static func handelURLResponse(output:URLSession.DataTaskPublisher.Output, url: URL) throws -> Data{
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    static func handelComplition(completion: Subscribers.Completion<Error>){
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error)
        }
    }
}
