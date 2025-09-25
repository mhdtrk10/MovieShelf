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
            Task {
                await aggregateByName()
                
            }
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
    
    func recalcTotalInt() -> Int {
        cartMovieList.reduce(0) { $0 + (( $1.price ?? 0) * ( $1.orderAmount ?? 0)) }
    }
    
    func firstCartIndex(matchingAggregatedName name: String) -> Int? {
        let key = normalize(name)
        return cartMovieList.firstIndex { normalize($0.name) == key }
    }
    func normalize(_ raw: String?) -> String {
        (raw ?? "-").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    
    
    
    func aggregateByName() async {
        
        let grouped = Dictionary(grouping: cartMovieList, by: { $0.name })
        let rows: [AggregatedCartRow] = grouped.map { (name, group) in
            let displayName = group.first?.name!
            let image = group.first?.image!
            let price = group.first?.price!
            let category = group.first?.category!
            let rating = group.first?.rating!
            let year = group.first?.year!
            let director = group.first?.director!
            let description = group.first?.description!
            let orderAmount = group.first?.orderAmount!
            let userName = group.first?.userName!
            let totalQty = group.reduce(0) { $0 + $1.orderAmount! }
            
            let totalPrice: Int? = {
                guard let _ = price else { return nil }
                return group.reduce(0) { $0 + ($1.price! * $1.orderAmount!) }
            }()
            
            let cartId: Int? = group.first?.cartId
            
            return AggregatedCartRow(
                cartId: cartId!,
                name: displayName!,
                image: image!,
                price: price!,
                category: category!,
                rating: rating!,
                year: year!,
                director: director!,
                description: description!,
                orderAmount: orderAmount!,
                userName: userName!,
                totalQty: totalQty,
                totalPrice: totalPrice
            )
        }
        self.aggregated = rows.sorted(by: { $0.name! < $1.name! })
    }

}
