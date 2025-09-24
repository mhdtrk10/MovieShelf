//
//  FilmScreen.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 19.09.2025.
//

import SwiftUI

struct FilmScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    var movies = Movies()
    var viewModel = FilmViewModel()
    @ObservedObject var cartviewModel = CartViewModel()
    var body: some View {
        ZStack {
            Color(AppColors.krem)
                .ignoresSafeArea(.all)
            
            VStack(alignment: .center, spacing: 8) {
                VStack(spacing: 8) {
                
                    VStack {
                        AsyncImage(url: URL(string: "http://kasimadalan.pe.hu/movies/images/\(movies.image!)")) { phase in
                            if let image = phase.image {
                                
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250, height: 300)
                                    .padding(.top,8)
                                    .cornerRadius(16)
                            } else if phase.error != nil {
                                Color.red.overlay(Text("Hata"))
                            } else {
                                ProgressView()
                            }
                        }
                    }
                    .frame(width: 200, height: 250)
                    .cornerRadius(16)
                    
                    Text(movies.name!)
                        .font(.headline)
                        .foregroundColor(AppColors.barColor)
                    
                    HStack(spacing: 4) {
                        Text("Yapım Yılı: ")
                            .font(.subheadline)
                            .foregroundColor(AppColors.barColor)
                            .padding(.leading, 8)
                        
                        Text("\(String(Int(movies.year!)))")
                            .font(.subheadline)
                            .foregroundColor(AppColors.barColor)
                    }
                    .frame(width: 250, height: 30, alignment: .leading)
                    .background(Color(AppColors.krem))
                    .cornerRadius(8)
                    
                    HStack(spacing: 4) {
                        Text("Senarist: ")
                            .font(.subheadline)
                            .foregroundColor(AppColors.barColor)
                            .padding(.leading, 8)
                        
                        Text("\(movies.director!)")
                            .font(.subheadline)
                            .foregroundColor(AppColors.barColor)
                    }
                    .frame(width: 250, height: 30, alignment: .leading)
                    .background(Color(AppColors.krem))
                    .cornerRadius(8)
                    
                    HStack(spacing: 4) {
                        Text("IMDb: ")
                            .font(.subheadline)
                            .foregroundColor(AppColors.barColor)
                            .padding(.leading, 8)
                        
                        Text("\(String(format: "%.2f", movies.rating!))")
                            .font(.subheadline)
                            .foregroundColor(AppColors.barColor)
                    }
                    .frame(width: 250, height: 30, alignment: .leading)
                    .background(Color(AppColors.krem))
                    .cornerRadius(8)
                    
                    HStack(spacing: 4) {
                        Text("Kategori: ")
                            .font(.subheadline)
                            .foregroundColor(AppColors.barColor)
                            .padding(.leading, 8)
                        
                        Text("\(movies.category!)")
                            .font(.subheadline)
                            .foregroundColor(AppColors.barColor)
                    }
                    .frame(width: 250, height: 30, alignment: .leading)
                    .background(Color(AppColors.krem))
                    .cornerRadius(8)
                    
                    HStack {
                        Text("\(movies.description!)")
                            .padding(.leading, 8)
                            .padding(.trailing,8)
                            .foregroundColor(AppColors.barColor)
                    }
                    .frame(width: 250, height: 130, alignment: .leading)
                    .background(Color(AppColors.krem))
                    .cornerRadius(8)
                    
                    HStack(spacing: 4) {
                        Text("Fiyat: ")
                            .font(.subheadline)
                            .foregroundColor(AppColors.barColor)
                            .padding(.leading, 8)
                        
                        Text("\(movies.price!) Türk Lirası")
                            .font(.subheadline)
                            .foregroundColor(AppColors.barColor)
                    }
                    .frame(width: 250, height: 30, alignment: .leading)
                    .background(Color(AppColors.krem))
                    .cornerRadius(8)
                    
                    
                }
                .frame(width: 350, height: 620, alignment: .top)
                .padding(.top,8)
                .background(Color(AppColors.lacivert))
                .cornerRadius(16)
                
                Button {
                    Task {
                        await viewModel.save(name: movies.name!, image: movies.image!, price: movies.price!, category: movies.category!, rating: movies.rating!, year: movies.year!, director: movies.director!, description: movies.description!, orderAmount: 1, userName: "mehdi_oturak")
                    }
                } label: {
                    Text("Sepete Ekle")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(width: 250, height: 50)
                        .foregroundColor(AppColors.barColor)
                        .background(Color(AppColors.lacivert))
                }
                .cornerRadius(16)
                //.background(Color(AppColors.lacivert))
                
                
                
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
            .padding(.top,8)
            .background(Color.gray.opacity(0.3))
            .navigationTitle("\(movies.name!)")
        }
    }
}

#Preview {
    FilmScreen()
}
