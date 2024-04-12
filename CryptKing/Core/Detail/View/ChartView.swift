//
//  ChartView.swift
//  CryptKing
//
//  Created by Akshay Kadam on 12/04/24.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColour: Color
    private let startDate: Date
    private let endDate: Date
    @State private var percenatge: CGFloat = 0
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColour = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        endDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startDate = endDate.addingTimeInterval(7*24*60*60)
    }
    
    var body: some View {
        VStack{
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay {chartYAxis
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)
                }
//            HStack{
//                Text(startDate.asShortDateString())
//                Spacer()
//                Text(endDate.asShortDateString())
//            }
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                withAnimation(.linear(duration: 2.0)) {
                    percenatge = 1.0
                }
            }
        }
    }
}

#Preview {
    ChartView(coin: DeveloperPreview.instance.coin)
}

extension ChartView{
    
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices{
                    
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    
                    let yPosition = (1 - CGFloat((data[index] - minY)/yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percenatge)
            .stroke(lineColour,style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round ))
            .shadow(color: lineColour.opacity(0.5), radius: 10, x: 0.0, y: 10)
            .shadow(color: lineColour.opacity(0.2), radius: 10, x: 0.0, y: 20)
            .shadow(color: lineColour.opacity(0.1), radius: 10, x: 0.0, y: 30)

        }
    }
    
    private var chartBackground: some View{
        VStack{
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View{
        VStack{
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            let price = (maxY + minY) / 2
            Text(price.formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
}
