//
//  FilmScreenViewModel.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 19.09.2025.
//

import Foundation
@MainActor
class FilmViewModel {
    
    private let repository = movieRepository()
    
    func save(name: String, image: String, price: Int, category: String, rating: Double, year: Int, director: String, description: String, orderAmount: Int, userName: String ) async {
        do {
            try await repository.save(name: name, image: image, price: price, category: category, rating: rating, year: year, director: director, description: description, orderAmount: orderAmount, userName: userName)
        } catch {
            
        }
    }
    
}
