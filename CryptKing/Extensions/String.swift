//
//  String.swift
//  CryptKing
//
//  Created by Akshay Kadam on 12/04/24.
//

import Foundation

extension String {
    
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
