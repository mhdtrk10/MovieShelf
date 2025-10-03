//
//  HomeScreen.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 1.10.2025.
//

import SwiftUI

struct HomeScreen: View {
    @State private var selection: Tab = .home
    @Namespace private var underlineNS
    
    
    var body: some View {
        TabView(selection: $selection) {
            /*
            MainScreen()
                .tabItem {
                    Image(systemName: "house")
                    
                }
            CartScreen()
                .tabItem {
                    Image(systemName: "cart")
                }
             */
            MainScreen().tag(Tab.home)
                
            CartScreen().tag(Tab.cart)
                
        }
        .tint(Color(.black))
        // Sistem tab barı kapat
        .toolbar(.hidden, for: .tabBar) // iOS 16+
        
        // Alt kısma kendi bar'ımızı oturt
        .safeAreaInset(edge: .bottom) {
            CustomTabBar(selection: $selection, ns: underlineNS)
            
        }

    }
}




#Preview {
    HomeScreen()
}
