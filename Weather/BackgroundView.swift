//
//  BackgroundView.swift
//  Weather
//
//  Created by Oleg Yakushin on 4/16/24.
//

import SwiftUI

enum WeatherType {
    case sunny, cloudy, night
}

struct BackgroundView: View {
    var weatherType: WeatherType
    
    var body: some View {
        switch weatherType {
        case .sunny:
            return AnyView(SunnyBackgroundView())
        case .cloudy:
            return AnyView(CloudyBackgroundView())
        case .night:
            return AnyView(NightBackgroundView())
        }
    }
}

struct SunnyBackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }
}

struct CloudyBackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.blue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }
}

struct NightBackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    Group {
        BackgroundView(weatherType: .sunny)
        BackgroundView(weatherType: .cloudy)
        BackgroundView(weatherType: .night)
    }
}
