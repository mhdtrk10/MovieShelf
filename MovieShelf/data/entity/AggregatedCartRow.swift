//
//  AggregatedCartRow.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 23.09.2025.
//

import Foundation

struct AggregatedCartRow: Identifiable {
    let id = UUID()
    let name: String?
    let totalQty: Int
    let unitPrice: Int?    
    let totalPrice: Int?
}
