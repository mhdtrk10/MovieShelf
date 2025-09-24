//
//  MovieListItem.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 19.09.2025.
//

import SwiftUI

struct MovieListItem: View {
    var movies = Movies()
    var filmViewModel = FilmViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            
            VStack {
                AsyncImage(url: URL(string: "http://kasimadalan.pe.hu/movies/images/\(movies.image!)")) { phase in
                    if let image = phase.image {
                        
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 200)
                            .padding(.top,8)
                            //.cornerRadius(24)
                    } else if phase.error != nil {
                        Color.red.overlay(Text("Hata"))
                    } else {
                        ProgressView()
                    }
                }
            }
            .frame(width: 150, height: 200)
            .cornerRadius(32)
            Text(movies.name!)
                .foregroundColor(AppColors.barColor)
                .font(.subheadline.bold())
                .lineLimit(2)
            HStack(alignment: .center,spacing: 6) {
                Text("Fiyat : \(movies.price!) ₺")
                    .foregroundColor(AppColors.barColor)
                    .padding(.leading,4)
                    .font(.system(size: 15))
                

                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack() {
                Text("IMDb: \(String(format: "%.2f", movies.rating!))")
                    .foregroundColor(AppColors.barColor)
                    .padding(.leading,4)
                    .font(.system(size: 15))
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 6) {
                Text(movies.category!)
                    .font(.system(size: 10))
                    .foregroundColor(AppColors.barColor)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Color.gray.opacity(0.5))
                    .clipShape(Capsule())
                
                Spacer()
            }
            .padding(.leading,4)
            .padding(.bottom,4)
            
            Button {
                Task {
                    await filmViewModel.save(name: movies.name!, image: movies.image!, price: movies.price!, category: movies.category!, rating: movies.rating!, year: movies.year!, director: movies.director!, description: movies.description!, orderAmount: 1, userName: "mehdi_oturak")
                }
            } label: {
                Text("Sepete Ekle")
                    .font(.caption)
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .frame(width: 120, height: 30)
                    .foregroundColor(AppColors.barColor)
                    .background(Color.gray.opacity(0.3))
            }
            .cornerRadius(8)
            
            Spacer()
        }
        .background(Color.gray.opacity(0.15))
        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
        .padding(.bottom,4)
        .cornerRadius(8)
    }
}

#Preview {
    MovieListItem()
}
