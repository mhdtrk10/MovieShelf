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
                .foregroundColor(Color(AppColors.White))
                .font(.subheadline.bold())
                .lineLimit(2)
            
            
            VStack {
                HStack {
                    Text("Fiyat : \(movies.price!) TL")
                        .foregroundColor(Color(AppColors.White))
                        .padding(.leading,4)
                        .font(.system(size: 15))
                        .padding(4)

                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 4).fill(Color(AppColors.barPurp)).stroke(Color(AppColors.backPurp), lineWidth: 1))
                .padding(.trailing,8)
                HStack {
                    Text("IMDb: \(String(format: "%.2f", movies.rating!))")
                        .foregroundColor(Color(AppColors.White))
                        .padding(.leading,4)
                        .font(.system(size: 15))
                        .padding(4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 4).fill(Color(AppColors.barPurp)).stroke(Color(AppColors.backPurp), lineWidth: 1))
                .padding(.trailing,8)

                HStack(spacing: 6) {
                    
                    Text(movies.category!)
                        .font(.system(size: 10))
                        .foregroundColor(Color(AppColors.White))
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color(AppColors.backPurp.opacity(0.7)))
                        .clipShape(Capsule())
                    Spacer()
                    
                }
                .padding(.trailing,4)
                .padding(.bottom,4)
                
            }
            .padding(.leading, 8)
            
            Spacer()
        }
        .background(Color(AppColors.barPurp))
        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
        .padding(.bottom,4)
        .cornerRadius(8)
    }
}

#Preview {
    MovieListItem()
}
