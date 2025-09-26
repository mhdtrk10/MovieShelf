//
//  CartScreen.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 19.09.2025.
//

import SwiftUI

struct CartScreen: View {
    
    @ObservedObject var viewModel = CartViewModel()
    var filmViewModel = FilmViewModel()
    var body: some View {
        ZStack {
            Color(AppColors.lacivert)
                .ignoresSafeArea(edges: .all)
            
            
            if viewModel.aggregated.isEmpty {
                Text("Sepet boş!")
                    .foregroundColor(AppColors.barColor)
            } else {
                VStack {
                    List {
                        ForEach(viewModel.aggregated) { movie in
                            HStack {
                                
                                AsyncImage(url: URL(string: "http://kasimadalan.pe.hu/movies/images/\(movie.image!)")) { phase in
                                    if let image = phase.image {
                                        
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 80)
                                            .padding(.top,8)
                                            .cornerRadius(8)
                                    } else if phase.error != nil {
                                        Color.red.overlay(Text("Hata"))
                                    } else {
                                        ProgressView()
                                    }
                                }
                                .padding(4)
                                .padding(.bottom,4)
                                
                                HStack {
                                    
                                    VStack(alignment: .leading) {
                                        Text("\(movie.name!)")
                                            .foregroundColor(AppColors.barColor)
                                            .font(.system(size: 15))
                                        
                                        Spacer()
                                        Text("Adet : \(movie.totalQty!)")
                                            .foregroundColor(AppColors.barColor)
                                            .font(.system(size: 13))
                                    }
                                    .frame(maxHeight: .infinity,alignment: .top)
                                    .padding(.top, 16)
                                    .padding(.bottom, 24)
                                    Spacer()
                                    
                                    HStack {
                                        Button {
                                            Task {
                                                guard let name = movie.name,
                                                      let Idx = viewModel.firstCartIndex(matchingAggregatedName: name)
                                                else { return }
                                                
                                                let raw = viewModel.cartMovieList[Idx]
                                                let currentQty = raw.orderAmount ?? 1
                                                
                                                if currentQty > 1 {
                                                    await viewModel.updateOrderAmount(
                                                        cartId: raw.cartId!,
                                                        newAmount: currentQty - 1,
                                                        userName: "mehdi_oturak"
                                                    )
                                                } else {
                                                    await viewModel.delete(cartId: raw.cartId!, userName: "mehdi_oturak")
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "minus.square.fill")
                                                .foregroundColor(AppColors.barColor)
                                        }
                                        .buttonStyle(.borderless)

                                        .padding(.trailing,8)
                                        
                                        Button {
                                            Task {
                                                await filmViewModel.save(name: movie.name!, image: movie.image!, price: movie.price!, category: movie.category!, rating: movie.rating!, year: movie.year!, director: movie.director!, description: movie.description!, orderAmount: 1, userName: "mehdi_oturak")
                                                await viewModel.loadCartMovies(userName: "mehdi_oturak")
                                            }
                                        } label: {
                                            Image(systemName: "plus.square.fill")
                                            
                                                .foregroundColor(AppColors.barColor)
                                        }
                                        .buttonStyle(.borderless)
                                        
                                    }
                                    .padding(.trailing, 8)
                                    
                                }
                                HStack {
                                    if let totalPrice = movie.totalPrice {
                                        Text("\(totalPrice) TL")
                                            .foregroundColor(AppColors.barColor)
                                            .font(.headline)
                                    }
                                }
                                .frame(width: 80, height: 40)
                                
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.krem)
                                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                            )
                            
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom,8)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            
                        }
                        .onDelete { offsets in
                            guard let aggIndex = offsets.first else { return }
                            let row = viewModel.aggregated[aggIndex]
                            Task { await viewModel.deleteAll(fromAggregated: row, userName: "mehdi_oturak") }
                        }
                        
                    }
                    .padding(.bottom, 48)
                    .scrollContentBackground(.hidden)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                
            }
            
            
            VStack {
                HStack(spacing: 8) {
                    Button {
                        
                    } label: {
                        Text("Sepeti Onayla")
                            .foregroundColor(AppColors.barColor)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(maxWidth: 200, maxHeight: 50, alignment: .center)
                            .background(RoundedRectangle(cornerRadius: 4).fill(Color(AppColors.krem)))
                        
                    }
                    .buttonStyle(PressableStyle())
                    Text("\(viewModel.recalcTotalInt()) TL")
                        .foregroundColor(AppColors.barColor)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .frame(maxWidth: 200, maxHeight: 50, alignment: .center)
                        .background(RoundedRectangle(cornerRadius: 4).fill(Color(AppColors.krem)))
                }
                .frame(maxWidth: .infinity, maxHeight: 70)
                .background(AppColors.lacivert)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            
            
            
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
