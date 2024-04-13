//
//  CornerModifier.swift
//  Weather
//
//  Created by Oleg Yakushin on 4/9/24.
//

import SwiftUI

struct CornerModifier: ViewModifier {
    @Binding var bottomOffset: CGFloat
    
    func body(content: Content) -> some View {
        if bottomOffset < 38 {
            content
        } else {
            content.cornerRadius(12)
        }
    }
}
