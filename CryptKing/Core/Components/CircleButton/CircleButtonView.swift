//
//  CircleButtonView.swift
//  CryptKing
//
//  Created by Akshay Kadam on 28/03/24.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(Color.theme.background)
            )
            .shadow(color: Color.theme.accent.opacity(0.25) ,radius: 10)
            .padding()
    }
}

#Preview {
    CircleButtonView(iconName: "info")
        .previewLayout(.sizeThatFits)
}
