//
//  MainScreen.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 19.09.2025.
//

import SwiftUI

struct MainScreen: View {
    
    @ObservedObject var viewModel = MainViewModel()
    
    
    init() {
        NavigationBarStyle.setupNavigationBar()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(AppColors.krem)
                    .ignoresSafeArea(.all)
                
                
                
                VStack {
                    HStack {
                        
                        NavigationLink(destination: CartScreen()) {
                            Text("Sepeti Görüntüle")
                                .foregroundColor(AppColors.barColor)
                                .frame(width: 150, height: 30, alignment: .leading)
                                .padding()
                        }
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .font(.headline)
                                .foregroundColor(AppColors.barColor)
                                .padding(.trailing, 32)
                                .padding(.top, 8)
                                
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    if viewModel.movieList.isEmpty {
                        Text("No movies Yet !").foregroundStyle(.white)
                    } else {
                        ScrollView {
                            
                            
                            
                            LazyVGrid(
                                columns: [GridItem(.flexible(), spacing: 12),
                                          GridItem(.flexible(), spacing: 12)],
                                
                                            
                                spacing: 8
                            ) {
                                ForEach(viewModel.movieList) { movie in
                                    NavigationLink(destination: FilmScreen(movies: movie)) {
                                        MovieListItem(movies: movie)
                                    }
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .cornerRadius(8)
                            
                            
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .navigationTitle("MovieShelf")
                .onAppear {
                    Task {
                        await viewModel.loadMovies()
                        
                    }
                }
                
                
            }
        }
        .tint(Color(AppColors.barColor))
        
    }
}



#Preview {
    MainScreen()
}
