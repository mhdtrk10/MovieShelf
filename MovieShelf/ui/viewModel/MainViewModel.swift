//
//  MainScreenViewModel.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 19.09.2025.
//

import Foundation
@MainActor
class MainViewModel : ObservableObject {
    
    private let repository = movieRepository()
    @Published var movieList = [Movies]()
    
    func loadMovies() async {
        do {
            try await movieList = repository.loadMovies()
        } catch {
            
            movieList = [Movies]()
        }
    }
    
}
