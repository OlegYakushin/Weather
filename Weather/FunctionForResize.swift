//
//  FunctionForResize.swift
//  Weather
//
//  Created by Oleg Yakushin on 4/13/24.
//

import SwiftUI
func sizeScreenIphone() -> CGFloat {
    if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
        return UIScreen.main.bounds.width / 844
    } else {
        return UIScreen.main.bounds.width / 390
    }
}

