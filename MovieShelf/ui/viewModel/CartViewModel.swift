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
    @Published var cartMovieList = [CartMovies]() {
        didSet {
            Task { await aggregateByName() }
        }
    }
    
    @Published var aggregated: [AggregatedCartRow] = []
    
    
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
    
    func firstCartIndex(matchingAggregatedName name: String) -> Int? {
        let key = normalize(name)
        return cartMovieList.firstIndex { normalize($0.name) == key }
    }
    private func normalize(_ raw: String?) -> String {
        (raw ?? "-").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    
    func aggregateByName() async {
        
        
        let grouped = Dictionary(grouping: cartMovieList, by: { $0.name })
        
        let rows: [AggregatedCartRow] = grouped.map { (name, group) in
            let totalQty = group.reduce(0) { $0 + $1.orderAmount! }
            
            let unitPrice = group.first?.price
            let totalPrice: Int? = {
                guard let _ = unitPrice else { return nil }
                return group.reduce(0) { $0 + ($1.price! * $1.orderAmount!) }
            }()
            
            return AggregatedCartRow(
                name: name!,
                totalQty: totalQty,
                unitPrice: unitPrice,
                totalPrice: totalPrice
            )
        }
        self.aggregated = rows.sorted(by: { $0.name! < $1.name! })
        
        
    }
}
