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
    
    // sepetteki bütün fimler
    func loadCartMovies(userName: String) async {
        do {
            let result = try await repository.loadCartMovies(userName: userName)
            cartMovieList = result
            
        } catch {
            cartMovieList = [CartMovies]()
        }
    }
    // silme
    func delete(cartId: Int, userName: String) async {
        do {
            try await repository.delete(cartId: cartId, userName: userName)
            await loadCartMovies(userName: "mehdi_oturak")
            
        } catch {
            
        }
    }
    // bir adet silme için eğer bir tane kaldıysa direkt silme
    func updateOrderAmount(cartId: Int, newAmount: Int, userName: String) async {
        guard let item = cartMovieList.first(where: { $0.cartId == cartId }) else { return }
        
        await delete(cartId: cartId, userName: userName)
        
        
        do {
            try await repository.save(
                name: item.name!,
                image: item.image!,
                price: item.price!,
                category: item.category!,
                rating: item.rating!,
                year: item.year!,
                director: item.director!,
                description: item.description!,
                orderAmount: newAmount,
                userName: userName
            )
        } catch {
            
        }

        await loadCartMovies(userName: userName)
    }
    // toplam fiyat
    func recalcTotalInt() -> Int {
        cartMovieList.reduce(0) { $0 + (( $1.price ?? 0) * ( $1.orderAmount ?? 0)) }
    }
    // dışarıdan gelen name i normalize edip listedeki öğeye eşitliği arar bulduğunda indexi döndürür.
    func firstCartIndex(matchingAggregatedName name: String) -> Int? {
        let key = normalize(name)
        return cartMovieList.firstIndex { normalize($0.name) == key }
    }
    // boşlukları silip küçük harfe çevirme
    func normalize(_ raw: String?) -> String {
        (raw ?? "-").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    // hepsini silme
    func deleteAll(fromAggregated row: AggregatedCartRow, userName: String = "mehdi_oturak") async {
        guard let name = row.name else { return }
        let key = normalize(name)
        
        let ids = cartMovieList
            .filter { normalize($0.name) == key }
            .compactMap { $0.cartId }
        
        for id in ids {
            do { try await repository.delete(cartId: id, userName: userName) } catch { }
        }
        await loadCartMovies(userName: userName)
    }
    // yeni diziye aktarıp gruplandırma işlemi
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
