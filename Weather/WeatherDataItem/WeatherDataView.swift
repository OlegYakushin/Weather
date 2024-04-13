//
//  WeatherDataView.swift
//  Weather
//
//  Created by Oleg Yakushin on 4/13/24.
//

import SwiftUI
import WeatherKit

struct WeatherDataView: View {
    var currentWeather: CurrentWeather
    
    var body: some View {
        
        VStack(spacing: 8) {
//            airQualityView()
            
            HStack {
                UVIndexView(uvIndex: currentWeather.uvIndex)
                WindView(wind: currentWeather.wind)
            }.frame(maxHeight: .infinity)
            
            HStack {
                FeelslikeView(currentWeather: currentWeather)
                HumidityView(currentWeather: currentWeather)
            }.frame(maxHeight: .infinity)

            HStack {
                VisibilityView(currentWeather: currentWeather)
                PressureView(currentWeather: currentWeather)
            }.frame(maxHeight: .infinity)

        }
    }
}
