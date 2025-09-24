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
    @Published var query: String = ""
    
    @Published var sort: SortOption = .nameAZ
    enum SortOption: CaseIterable, Hashable {
            case nameAZ, nameZA
            case yearAsc, yearDesc
            case priceAsc, priceDesc
            case ratingAsc, ratingDesc

            var title: String {
                switch self {
                case .nameAZ:     return "İsim A→Z"
                case .nameZA:     return "İsim Z→A"
                case .yearAsc:    return "Yıl Artan"
                case .yearDesc:   return "Yıl Azalan"
                case .priceAsc:   return "Fiyat Artan"
                case .priceDesc:  return "Fiyat Azalan"
                case .ratingAsc:  return "IMDb Artan"
                case .ratingDesc: return "IMDb Azalan"
                }
            }
        }
    
    
    
    var filtered: [Movies] {
        let filtered = filter(movieList, by: query)
        return sortList(filtered, by: sort)
    }
    
    func loadMovies() async {
        do {
            try await movieList = repository.loadMovies()
        } catch {
            
            movieList = [Movies]()
        }
    }
    
    private func normalizeForSearch(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let folded  = trimmed.folding(options: [.diacriticInsensitive, .caseInsensitive],
                                      locale: Locale(identifier: "tr_TR"))
        return folded.replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
    }
    
    private func fuzzyContains(_ haystack: String?, _ needle: String) -> Bool {
        let h = normalizeForSearch(haystack ?? "")
        let n = normalizeForSearch(needle)
        guard !n.isEmpty else { return true }
        return h.contains(n)
    }
    
    
    private func filter(_ list: [Movies], by q: String) -> [Movies] {
        let q = q.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return list }
        return list.filter { ($0.name ?? "").localizedCaseInsensitiveContains(q) }
    }
    
    private func sortList(_ list: [Movies], by option: SortOption) -> [Movies] {
        let tr = Locale(identifier: "tr_TR")
        return list.sorted { a, b in
            switch option {
            case .nameAZ:
                let an = a.name ?? "", bn = b.name ?? ""
                let cmp = an.compare(bn, options: [.caseInsensitive, .diacriticInsensitive], locale: tr)
                return cmp == .orderedAscending
            case .nameZA:
                let an = a.name ?? "", bn = b.name ?? ""
                let cmp = an.compare(bn, options: [.caseInsensitive, .diacriticInsensitive], locale: tr)
                return cmp == .orderedDescending
                
            case .yearAsc:   return lessThanOptional(a.year,   b.year,   ascending: true)
            case .yearDesc:  return lessThanOptional(a.year,   b.year,   ascending: false)
                
            case .priceAsc:  return lessThanOptional(a.price,  b.price,  ascending: true)
            case .priceDesc: return lessThanOptional(a.price,  b.price,  ascending: false)
                
            case .ratingAsc: return lessThanOptional(a.rating, b.rating, ascending: true)
            case .ratingDesc:return lessThanOptional(a.rating, b.rating, ascending: false)
            }
        }
    }
    
    
    private func lessThanOptional<T: Comparable>(_ a: T?, _ b: T?, ascending: Bool) -> Bool {
        switch (a, b) {
        case let (x?, y?): return ascending ? (x < y) : (x > y)
        case (nil, nil):   return false
        case (nil, _):     return false
        case (_, nil):     return true
        }
    }
    
}


