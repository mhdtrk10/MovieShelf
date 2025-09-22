//
//  CartScreenViewModel.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 19.09.2025.
//

import Foundation
@MainActor
class CartViewModel : ObservableObject {
    private let repository = movieRepository()
    @Published var cartMovieList = [CartMovies]()
    
    func loadCartMovies(userName: String) async {
        do {
            let result = try await repository.loadCartMovies(userName: userName)
            cartMovieList = result
        } catch {
            cartMovieList = [CartMovies]()
        }
    }
    
    func delete(cartId: Int, userName: String) async {
        do {
            try await repository.delete(cartId: cartId, userName: userName)
            await loadCartMovies(userName: "mehdi_oturak")
        } catch {
            
        }
    }
}
