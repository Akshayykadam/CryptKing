//
//  HapticManager.swift
//  CryptKing
//
//  Created by Akshay Kadam on 07/04/24.
//

import Foundation
import SwiftUI

class HapticManager{
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(notificationType: UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(notificationType)
    }
}
