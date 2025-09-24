//
//  MainScreen.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 19.09.2025.
//

import SwiftUI

struct MainScreen: View {
    
    @ObservedObject var viewModel = MainViewModel()
    @State private var searchText = ""
    @State private var showSearch = false
    
    
    init() {
        NavigationBarStyle.setupNavigationBar()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(AppColors.krem)
                    .ignoresSafeArea(.all)
                
                
                
                VStack {
                    HStack(spacing: 4) {
                        
                        Button {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                showSearch.toggle()
                            }
                            
                        } label: {
                            Image(systemName: showSearch ? "xmark.circle" : "magnifyingglass")
                        }
                        .padding(.leading, 8)
                        if showSearch {
                            TextField("", text: $viewModel.query, prompt: Text("Search").foregroundColor(AppColors.barColor))
                                .foregroundColor(AppColors.barColor)
                                .padding(10)
                                .background(Color(AppColors.lacivert))
                                .cornerRadius(10)
                                .transition(.move(edge: .leading).combined(with: .opacity))
                                .overlay(alignment: .trailing) {
                                    if !viewModel.query.isEmpty {
                                        Button {
                                            viewModel.query = ""
                                            
                                            
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(AppColors.barColor)
                                                .imageScale(.small)
                                                .padding(.trailing, 8)
                                                .frame(width: 22, height: 22, alignment: .center) // rahat dokunma alanı
                                        }
                                        .transition(.scale.combined(with: .opacity))
                                        .animation(.easeInOut(duration: 0.15), value: viewModel.query.isEmpty)
                                    }
                                }
                        }
                        Spacer()
                        // SIRALAMA MENÜSÜ
                        Menu {
                            Button("İsme göre A → Z") { viewModel.sort = .nameAZ }
                            Button("İsme göre Z → A") { viewModel.sort = .nameZA }
                            Button("Yıla göre Artan")  { viewModel.sort = .yearAsc }
                            Button("Yıla göre Azalan") { viewModel.sort = .yearDesc }
                            Button("Fiyata göre Artan")  { viewModel.sort = .priceAsc }
                            Button("Fiyata göre Azalan") { viewModel.sort = .priceDesc }
                            Button("IMDb Artan")  { viewModel.sort = .ratingAsc }
                            Button("IMDb Azalan") { viewModel.sort = .ratingDesc }
                        } label: {
                            // Seçili sıralamayı kısa yazan buton
                            Label(viewModel.sort.title, systemImage: "arrow.up.arrow.down")
                                .labelStyle(.iconOnly) // istersen .titleAndIcon yap
                                .font(.title3)
                        }
                        .padding(.trailing,16)
                        .padding(4)
                        
                        
                        
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading,8)
                    .padding(.top,8)
                    
                    if viewModel.movieList.isEmpty {
                        Text("No movies Yet !").foregroundStyle(.white)
                    } else {
                        VStack {
                            ScrollView {

                                LazyVGrid(
                                    columns: [GridItem(.flexible(), spacing: 12),
                                              GridItem(.flexible(), spacing: 12)],
                                    
                                                
                                    spacing: 8
                                ) {
                                    ForEach(viewModel.filtered) { movie in
                                        NavigationLink(destination: FilmScreen(movies: movie)) {
                                            MovieListItem(movies: movie)
                                        }
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
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)
                                .cornerRadius(8)
                                
                                
                            }
                            VStack {
                                
                                NavigationLink(destination: CartScreen()) {
                                    Text("Sepeti Görüntüle")
                                        .foregroundColor(AppColors.barColor)
                                        .padding()
                                }
                                .background(Color.blue)
                                
                            }
                            .frame(maxWidth: .infinity, maxHeight: 30, alignment: .bottom)
                        }
                        //.padding(.bottom, 8)
                        
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
