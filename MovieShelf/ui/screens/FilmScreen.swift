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
    @State private var amount = 1
    var body: some View {
        ZStack {
            Color(AppColors.barPurp)
                .ignoresSafeArea(.all)
            
            VStack(alignment: .center) {
                VStack(spacing: 8) {
                
                    ScrollView {
                        VStack {
                            AsyncImage(url: URL(string: "http://kasimadalan.pe.hu/movies/images/\(movies.image!)")) { phase in
                                if let image = phase.image {
                                    
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 200)
                                        .padding(.top,8)
                                        .cornerRadius(16)
                                } else if phase.error != nil {
                                    Color.red.overlay(Text("Hata"))
                                } else {
                                    ProgressView()
                                }
                            }
                        }
                        .frame(width: 120, height: 170)
                        .cornerRadius(16)
                        
                        Text(movies.name!)
                            .font(.headline)
                            .foregroundColor(Color(AppColors.White))
                        
                        HStack(spacing: 4) {
                            Text("Yapım Yılı: ")
                                .font(.subheadline)
                                .foregroundColor(Color(AppColors.White))
                                .padding(.leading, 8)
                            
                            Text("\(String(Int(movies.year!)))")
                                .font(.subheadline)
                                .foregroundColor(Color(AppColors.White))
                        }
                        .frame(width: 200, height: 30, alignment: .leading)
                        .background(Color(AppColors.backPurp))
                        .cornerRadius(8)
                        
                        HStack(spacing: 4) {
                            Text("Senarist: ")
                                .font(.subheadline)
                                .foregroundColor(Color(AppColors.White))
                                .padding(.leading, 8)
                            
                            Text("\(movies.director!)")
                                .font(.subheadline)
                                .foregroundColor(Color(AppColors.White))
                        }
                        .frame(width: 200, height: 30, alignment: .leading)
                        .background(Color(AppColors.backPurp))
                        .cornerRadius(8)
                        
                        HStack(spacing: 4) {
                            Text("IMDb: ")
                                .font(.subheadline)
                                .foregroundColor(Color(AppColors.White))
                                .padding(.leading, 8)
                            
                            Text("\(String(format: "%.2f", movies.rating!))")
                                .font(.subheadline)
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 200, height: 30, alignment: .leading)
                        .background(Color(AppColors.backPurp))
                        .cornerRadius(8)
                        
                        HStack(spacing: 4) {
                            Text("Kategori: ")
                                .font(.subheadline)
                                .foregroundColor(Color.white)
                                .padding(.leading, 8)
                            
                            Text("\(movies.category!)")
                                .font(.subheadline)
                                .foregroundColor(Color(AppColors.White))
                        }
                        .frame(width: 200, height: 30, alignment: .leading)
                        .background(Color(AppColors.backPurp))
                        .cornerRadius(8)
                        
                        HStack {
                            Text("\(movies.description!)")
                                .padding(.leading, 8)
                                .padding(.trailing,8)
                                .foregroundColor(Color(AppColors.White))
                        }
                        .frame(width: 200, height: 130, alignment: .leading)
                        .background(Color(AppColors.backPurp))
                        .cornerRadius(8)
                        
                        
                        
                        HStack(spacing: 16) {
                            Picker("", selection: $amount) {
                                ForEach(1..<11) { number in
                                    Text("\(number)")
                                        .tag(number)
                                        .foregroundColor(Color(AppColors.White))
                                }
                            }
                            .padding(.horizontal, 4)
                            .frame(height: 25)
                            .background(Color(AppColors.barPurp))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            Text("\(amount * movies.price!) TL")
                                .font(.subheadline)
                                .foregroundColor(Color(AppColors.White))
                        }
                        .frame(width: 200, height: 30, alignment: .center)
                        .background(Color(AppColors.backPurp))
                        .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.bottom, 4)
                    
                }
                .frame(width: 300, height: 550, alignment: .top)
                .padding(.top,8)
                .background(Color(AppColors.barPurp))
                .cornerRadius(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.barPurp)
                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 3)
                )
                
                VStack {
                    Button {
                        Task {
                            await viewModel.save(name: movies.name!, image: movies.image!, price: movies.price!, category: movies.category!, rating: movies.rating!, year: movies.year!, director: movies.director!, description: movies.description!, orderAmount: amount, userName: "mehdi_oturak")
                        }
                    } label: {
                        Text("Sepete Ekle")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .frame(width: 300, height: 50,alignment: .center)
                            .foregroundColor(Color(AppColors.White))
                            .background(RoundedRectangle(cornerRadius: 4).fill(Color(AppColors.barPurp)))
                    }
                    .buttonStyle(PressableStyle())
                }
                .padding(.top,8)
                .padding(.bottom,12)

            }
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
            .padding(.top,8)
            .background(Color(AppColors.backPurp))
            .navigationTitle("\(movies.name!)")
        }
    }
}

#Preview {
    FilmScreen()
}
