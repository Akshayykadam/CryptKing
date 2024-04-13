//
//  PortfolioView.swift
//  CryptKing
//
//  Created by Akshay Kadam on 05/04/24.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoView
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Manage Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    //CloseButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavBarSaveButton
                }
            })
            
            .onChange(of: vm.searchText, perform: { value in
                if value == "" {
                    removeSelectedCoin()
                }
            })
        }
    }
}

//#Preview {
//    PortfolioView()
//        .environmentObject(DeveloperPreview.instance.homeVN)
//}

extension PortfolioView{
    
    private var coinLogoView: some View {
        ScrollView (.horizontal, showsIndicators: false ,content: {
            LazyHStack(spacing: 10){
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 60)
                        .padding(8)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSeletecCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedCoin?.id == coin.id ? Color.blue.opacity(0.2) : Color.clear)
                        )
                }
            }
            .padding(.vertical, 8)
            .padding(.leading)
        })
    }
    
    private func updateSeletecCoin(coin: CoinModel){
        selectedCoin = coin
        
        if let portfolioCoin = vm.portfolioCoins.first(where: {$0.id == coin.id}),
           let amout = portfolioCoin.currentHoldings{
            quantityText = "\(amout)"
        } else {
            quantityText = ""
        }
        
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20){
            HStack{
                Text("Curent \(selectedCoin?.symbol.uppercased() ?? "") Price :")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrenacyWith6Decimals() ?? "")
            }
            Divider()
            HStack{
                Text("Portfolio Value:")
                Spacer()
                TextField("Ex: 1.5", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            HStack{
                Text("Current Value:")
                Spacer()
                Text(getCurrentValue().asCurrenacyWith6Decimals())
            }
        }
        .padding()
        .font(.headline)
    }
    
    private var NavBarSaveButton: some View{
        HStack(spacing: 10){
            Button(action: {
               //Acttion
                saveButton()
            }, label: {
                Image(systemName: "plus.circle.fill")
                        .font(.headline)
            })
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0
            )
        }
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private func saveButton(){
        guard 
            let coin = selectedCoin,
            let amount = Double(quantityText)
        else {return}
        
        // Save In portfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        
        // show CheckMark
        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelectedCoin()
        }
        
        //hide keyboard
        UIApplication.shared.endEditing()
        
        //Hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            withAnimation(.easeOut){
                showCheckMark = false
            }
        }
    }
    
    private func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
        quantityText = ""
    }
    
}
