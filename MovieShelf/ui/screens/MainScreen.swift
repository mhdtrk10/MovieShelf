//
//  MainScreen.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 19.09.2025.
//

import SwiftUI

struct MainScreen: View {
    
    @ObservedObject var viewModel = MainViewModel()
    @State private var showSearch = false
    
    
    init() {
        NavigationBarStyle.setupNavigationBar()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(AppColors.backPurp)// AppColors.krem idi.
                    .ignoresSafeArea(.all)
                
                
                
                VStack {
                    HStack(spacing: 4) {
                        
                        Button {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                showSearch.toggle()
                            }
                            
                        } label: {
                            Image(systemName: showSearch ? "xmark.circle" : "magnifyingglass")
                                .foregroundColor(Color.white)
                        }
                        .padding(.leading, 8)
                        if showSearch {
                            TextField("", text: $viewModel.query, prompt: Text("Search..").foregroundColor(Color(AppColors.White)))
                                .foregroundColor(Color(AppColors.White))
                                .padding(10)
                                .background(Color(AppColors.barPurp))
                                .cornerRadius(10)
                                .transition(.move(edge: .leading).combined(with: .opacity))
                                .overlay(alignment: .trailing) {
                                    if !viewModel.query.isEmpty {
                                        Button {
                                            viewModel.query = ""
                                            
                                            
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(Color(AppColors.White))
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
                            
                            Label(viewModel.sort.title, systemImage: "arrow.up.arrow.down")
                                .foregroundColor(Color(AppColors.White))
                                .labelStyle(.iconOnly)
                                .font(.title3)
                        }
                        .padding(.trailing,16)
                        .padding(4)
                        
                        
                        
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading,8)
                    .padding(.top,8)
                    .padding(.bottom,4)
                    if viewModel.movieList.isEmpty {
                        Text("Filmler yok !")
                            .foregroundColor(Color.white)
                    } else {
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
                                        .fill(AppColors.barPurp)//AppColors.krem idi.
                                        .shadow(color: .black.opacity(0.6), radius: 5, x: 0, y: 3)
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        VStack {
                            
                            NavigationLink(destination: CartScreen()) {
                                Text("Sepeti Görüntüle")
                                    .foregroundColor(Color(AppColors.White))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                                    .background(RoundedRectangle(cornerRadius: 4).fill(Color(AppColors.barPurp)))
                                    .padding(.leading, 8)
                                    .padding(.trailing, 8)
                            }
                            .buttonStyle(PressableStyle())
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                        
                        
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
        .tint(Color.white)//AppColors.barColor idi.
        
    }
}



#Preview {
    MainScreen()
}
