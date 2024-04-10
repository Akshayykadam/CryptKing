//
//  CryptKingApp.swift
//  CryptKing
//
//  Created by Akshay Kadam on 26/03/24.
//

import SwiftUI

@main
struct CryptKingApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
