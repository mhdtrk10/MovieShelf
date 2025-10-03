//
//  Movies.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 19.09.2025.
//

import Foundation

class Movies: Identifiable,Codable {
    var id: Int?
    var name: String?
    var image: String?
    var price: Int?
    var category: String?
    var rating: Double?
    var year: Int?
    var director: String?
    var description: String?
     
    
    init() {
        
    }
    
    init(id: Int,name: String, image: String,price: Int, category: String, rating: Double, year: Int, director: String, description: String) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
        self.category = category
        self.rating = rating
        self.year = year
        self.director = director
        self.description = description
         
    }
    
}
enum Tab: Hashable, CaseIterable {
    case home, cart
    
    var title: String {
        switch self {
        case .home: return "Anasayfa"
        case .cart: return "Sepet"
        }
    }
    var systemImage: String {
        switch self {
        case .home: return "house.fill"
        case .cart: return "cart.fill"
        }
    }
}

