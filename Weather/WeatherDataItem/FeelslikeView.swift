//
//  FeelslikeView.swift
//  Weather
//
//  Created by Oleg Yakushin on 4/13/24.
//

import SwiftUI
import WeatherKit

struct FeelslikeView: View {
    var currentWeather: CurrentWeather
    
    var body: some View {
        CustomStackView {
            Label {
                Text("FEELS LIKE".uppercased())
            } icon: {
                Image(systemName: "thermometer.medium")
            }
            
        } contentView: {
            
            VStack(alignment: .leading) {
                let temp = currentWeather.apparentTemperature.value.rounded()
                let roundedTemperature = Int(temp)
                Text("\(roundedTemperature)°")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text(currentWeather.temperature.value > currentWeather.apparentTemperature.value
                     ? "Humidity is making it feel hotter"
                     : "Humidity is making it feel cooler")
                    .font(.callout)
                    .fontWeight(.regular)
                Spacer()

            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .leading)
        }
    }
}
