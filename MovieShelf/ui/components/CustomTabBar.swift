//
//  CustomTabBar.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 2.10.2025.
//

import SwiftUI

struct CustomTabBar: View {
    
    @Binding var selection: Tab
    let ns: Namespace.ID
    
    
    
    
    
    var body: some View {
        
        HStack {
            ForEach(Tab.allCases, id: \.self) { tab in
                VStack {
                    // ince çizgi alanı
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 120,height: 3)
                            
                        if selection == tab {
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 140,height: 3)
                                .matchedGeometryEffect(id: "underline", in: ns)
                        }
                    }
                    
                    // ikon
                    Image(systemName: tab.systemImage)
                        .padding(.top, 8)
                        .foregroundColor(selection == tab ? Color.black : Color.white)
                        //.font(.system(size: 18, weight: .semibold))
                        //.opacity(selection == tab ? 1 : 0.75)
                    // yazı
                    /*
                    Text(tab.title)
                        .font(.caption2)
                        .opacity(selection == tab ? 1 : 0.75)
                     */
                }
                .foregroundColor(.white)
                
                .frame(maxWidth: .infinity,maxHeight: 48)
                .padding(.horizontal, 4)
                
                .contentShape(Rectangle()) // tıklama alanını büyültme
                .onTapGesture {
                    // haptik + yaylı animasyonla seçimi değiştir.
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                        selection = tab
                    }
                }
                
                
            }
        }
        .frame(maxWidth: .infinity,maxHeight: 48 , alignment: .top)
        //.background(Color.brown)
        //.padding(.horizontal, 12)
       /*
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 120, height: 3)
                if Tab.home == selection {
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 120, height: 3)
                }
                
            }
            
            
        }
        */
        
        
    }
    
}


