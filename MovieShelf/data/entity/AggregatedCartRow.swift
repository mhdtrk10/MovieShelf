//
//  AggregatedCartRow.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 23.09.2025.
//

import Foundation

class AggregatedCartRow: Identifiable {
    var cartId: Int?
    var name: String?
    var image: String?
    var price: Int?
    var category: String?
    var rating: Double?
    var year: Int?
    var director: String?
    var description: String?
    var orderAmount: Int?
    var userName: String?
    var totalQty: Int?
    var totalPrice: Int?
    
    
    init() {
        
    }
    
    init(cartId: Int,name: String, image: String,price: Int, category: String, rating: Double, year: Int, director: String, description: String, orderAmount: Int, userName: String, totalQty: Int, totalPrice: Int?) {
        self.cartId = cartId
        self.name = name
        self.image = image
        self.price = price
        self.category = category
        self.rating = rating
        self.year = year
        self.director = director
        self.description = description
        self.orderAmount = orderAmount
        self.userName = userName
        self.totalQty = totalQty
        self.totalPrice = totalPrice
    }
    
}
