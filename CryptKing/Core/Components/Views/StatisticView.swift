//
//  StatisticView.swift
//  CryptKing
//
//  Created by Akshay Kadam on 04/04/24.
//

import SwiftUI

struct StatisticView: View {
    let stat: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            
            HStack {
                
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (stat.percentage ?? 0) >= 0 ? 0 : 180))
                
                Text(stat.percentage?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            
            .foregroundStyle((stat.percentage ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentage == nil ? 0.0:1.0)
        }
    }
}

#Preview {
    StatisticView(stat: DeveloperPreview.instance.state1)
}
 
