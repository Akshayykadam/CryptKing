//
//  StatisticModel.swift
//  CryptKing
//
//  Created by Akshay Kadam on 04/04/24.
//

import Foundation

public class StatisticModel: Identifiable {
    
    public let id: String
    public let title: String
    public let value: String
    public let percentage: Double?
    
    public init(title: String, value: String, percentage: Double? = nil) {
        self.id = UUID().uuidString
        self.title = title
        self.value = value
        self.percentage = percentage
    }
    
}
