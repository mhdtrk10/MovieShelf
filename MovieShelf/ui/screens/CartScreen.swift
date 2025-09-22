//
//  CartScreen.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 19.09.2025.
//

import SwiftUI

struct CartScreen: View {
    
    @ObservedObject var viewModel = CartViewModel()
    
    var body: some View {
        ZStack {
            Color(AppColors.lacivert)
                .ignoresSafeArea(edges: .all)
            
            List {
                ForEach(viewModel.cartMovieList) { movie in
                    Text("\(movie.name!)")
                }
                .onDelete(perform: delete)
            }
            
        }
        .onAppear {
            Task {
                await viewModel.loadCartMovies(userName: "mehdi_oturak")
            }
        }
        .navigationTitle(Text("Sepet"))
    }
    
    func delete(at offsets: IndexSet) {
        let movie = viewModel.cartMovieList[offsets.first!]
        Task {
            await viewModel.delete(cartId: movie.cartId!,userName: "mehdi_oturak")
        }
    }
}

#Preview {
    CartScreen()
}
