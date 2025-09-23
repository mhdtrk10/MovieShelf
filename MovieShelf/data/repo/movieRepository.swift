//
//  movieRepository.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 19.09.2025.
//

import Foundation

class movieRepository {
    
    //http://kasimadalan.pe.hu/movies/getAllMovies.php
    private let baseUrl = "http://kasimadalan.pe.hu/movies/"
    
    func loadMovies() async throws -> [Movies] {
        
        let apiUrl = "\(baseUrl)getAllMovies.php"
        
        guard let url = URL(string: apiUrl) else {
            throw URLError(.badURL)
        }

        let (data,_) = try await URLSession.shared.data(from: url)
        let moviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
        
        return moviesResponse.movies!
    }
    
    func save(name: String, image: String, price: Int, category: String, rating: Double, year: Int, director: String, description: String, orderAmount: Int, userName: String ) async throws {
        let apiUrl = "\(baseUrl)insertMovie.php"
        
        guard let url = URL(string: apiUrl) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let postString = "name=\(name)&image=\(image)&price=\(price)&category=\(category)&rating=\(rating)&year=\(year)&director=\(director)&description=\(description)&orderAmount=\(orderAmount)&userName=\(userName)"
        request.httpBody = postString.data(using: .utf8)
        
        let (data,_) = try await URLSession.shared.data(for: request)
        let crudResponse = try JSONDecoder().decode(CRUDResponse.self, from: data)
        print("Response : \(crudResponse.success!) \(crudResponse.message!) ")
        
    }
    
    func loadCartMovies(userName: String) async throws -> [CartMovies] {
        let apiUrl = "\(baseUrl)getMovieCart.php"
        
        guard let url = URL(string: apiUrl) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded; charset=utf-8",
                         forHTTPHeaderField: "Content-Type")
            
            
        let body = "userName=\(userName)"
        request.httpBody = body.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
        let cartResponse = try JSONDecoder().decode(CartResponse.self, from: data)
        
        
        return cartResponse.movie_cart ?? []
        
    }
    func delete(cartId: Int, userName: String) async throws {
        let apiUrl = "\(baseUrl)deleteMovie.php"
        
        
        guard let url = URL(string: apiUrl) else {
            throw URLError(.badURL)
        }
        
        // POST için
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "cartId=\(cartId)&userName=\(userName)"
        request.httpBody = postString.data(using: .utf8)
        
        let (data,_) = try await URLSession.shared.data(for: request)
        let crudResponse = try JSONDecoder().decode(CRUDResponse.self, from: data)
        print("Response : \(crudResponse.success!) \(crudResponse.message!) ")
    }
   
    
}
