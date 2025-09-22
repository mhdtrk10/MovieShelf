//
//  MovieShelfApp.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 19.09.2025.
//

import SwiftUI

@main
struct MovieShelfApp: App {
    var body: some Scene {
        WindowGroup {
            MainScreen().environment(\.font, .custom("Newsreader", size: 18))
        }
    }
}
