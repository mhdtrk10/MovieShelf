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
            
            /*
            List {
                ForEach(viewModel.cartMovieList) { movie in
                    Text("\(movie.name!)")
                    
                }
                .onDelete(perform: delete)
            }
            */
             
            /*
            List(viewModel.aggregated) { movie in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(movie.name!)")
                            .font(.caption)
                        if let totalPrice = movie.totalPrice {
                            Text("Toplam : \(totalPrice) tl")
                                .font(.subheadline)
                            
                        }
                        
                    }
                    Spacer()
                    Text("\(movie.totalQty)")
                        .font(.headline)
                    
                }
                .padding(.vertical, 4)
            }
             */
             
            List {
                ForEach(viewModel.aggregated) { movie in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(movie.name!)")
                                .font(.caption)
                            if let totalPrice = movie.totalPrice {
                                Text("Toplam : \(totalPrice) tl")
                                    .font(.subheadline)
                                
                            }
                            
                        }
                        Spacer()
                        Text("\(movie.totalQty)")
                            .font(.headline)
                    }
                }
                .onDelete { offsets in
                    guard let aggIndex = offsets.first else { return }
                    let row = viewModel.aggregated[aggIndex]
                    if let cartIdx = viewModel.firstCartIndex(matchingAggregatedName: row.name!) {
                        delete(at: IndexSet(integer: cartIdx))
                    }
                }
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
