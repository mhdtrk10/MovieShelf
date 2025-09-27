//
//  NavigationBarStyle.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 19.09.2025.
//

import Foundation
import SwiftUI



struct NavigationBarStyle {
    static func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(AppColors.barPurp)// AppColors.lacivert idi.
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(Color.white),//AppColors.barColor idi.
            .font: UIFont(name: "Newsreader", size: 22)!
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color.white),//AppColors.barColor idi.
            .font: UIFont(name: "Newsreader", size: 32)!
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        
    }
}
