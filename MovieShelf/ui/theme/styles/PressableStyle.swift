//
//  PressableStyle.swift
//  MovieShelf
//
//  Created by Mehdi Oturak on 25.09.2025.
//

import Foundation
import SwiftUI


struct PressableStyle: ButtonStyle {
    
    var pressedScale: CGFloat = 0.96
    var shadowRadius: CGFloat = 10
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : 1.0)
            .shadow(radius: configuration.isPressed ? 2 : shadowRadius)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}
