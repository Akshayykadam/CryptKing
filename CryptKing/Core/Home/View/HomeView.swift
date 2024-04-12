//
//  HomeView.swift
//  CryptKing
//
//  Created by Akshay Kadam on 26/03/24.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio: Bool = true
    @State private var showPortfolioView: Bool = false
    
    @State private var selectedCoin : CoinModel? = nil
    @State private var showDetailView: Bool = false
    
    @EnvironmentObject private var vm: HomeViewModel
    
    var body: some View {
        ZStack{
            
            //Background Layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {PortfolioView()
                        .environmentObject(vm)
                })
            
            //Content Layer
            NavigationStack{
                VStack{
                    HomeHeader
                    HomeStatsView(showPortfolio: $showPortfolio)
                    SearchBarView(searchText: $vm.searchText)
                    ColumnTitleView
                    if !showPortfolio{
                        AllCoinsListView
                        .transition(.move(edge: .leading))
                    }
                    if showPortfolio{
                        PortfolioCoinsListView
                        .transition(.move(edge: .trailing))
                    }
                    
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                }
            }
            .refreshable{
                vm.reloadData()
            }
        }
//        .background(
//            NavigationLink(
//                destination: DetailLoadingView(coin: $selectedCoin),
//                isActive: $showDetailView,
//                label: {
//                    EmptyView()
//                })
//            
//        )
         .sheet(isPresented: $showDetailView, content: {
             NavigationView {
                 DetailLoadingView(coin: $selectedCoin)
                     .navigationBarTitle("Detail", displayMode: .automatic)
             }
         })
    }
}

#Preview {
    NavigationView{
        HomeView()
            .navigationBarHidden(true)
    }
    .environmentObject(HomeViewModel())
}

extension HomeView{
    
    private var HomeHeader: some View{
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .onTapGesture {
                    if showPortfolio{
                        showPortfolioView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            
            Text(showPortfolio ? "Holdings" : "Live Market")
                .animation(.none)
                .font(.title3)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var AllCoinsListView: some View{
        List{
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        Segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var PortfolioCoinsListView: some View{
        List{
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        Segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func Segue(coin: CoinModel){
        //logic
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var ColumnTitleView: some View{
        HStack{
            HStack(spacing: 5) {
                Text("Coins")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio{
                HStack (spacing: 5){
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default){
                        vm.sortOption = vm.sortOption == .holdings ? .holdingReversed : .holdings
                    }
                }
            }
            HStack (spacing: 5){
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width/3, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            
//            Button {
//                withAnimation(.linear(duration: 2.0)){
//                    // Reload the data
//                    vm.reloadData()
//                }
//            } label: {
//                Image(systemName: "goforward")
//            }
//            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
}
