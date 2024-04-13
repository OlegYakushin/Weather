//
//  HourForecastItemView.swift
//  Weather
//
//  Created by Oleg Yakushin on 4/13/24.
//

import SwiftUI
import WeatherKit

struct HourForecastItemView: View {
    var hourWeather: HourWeather
    
    var timeFormat: Date.FormatStyle {
        Date.FormatStyle().hour(.defaultDigits(amPM: .omitted))
    }

    var body: some View {
        VStack(spacing: 4) {
            Text(hourWeather.date, format: timeFormat)
                .font(.callout.bold())
                .foregroundStyle(.white)
            
            Image(systemName: hourWeather.symbolName)
                .font(.title2)
                .symbolVariant(.fill)
                .symbolRenderingMode(.palette)
                .foregroundStyle((hourWeather.isDaylight && (hourWeather.condition == .mostlyClear || hourWeather.condition == .clear)) ? .yellow : .white)
                .frame(height: 30)
            let temp = hourWeather.temperature.value.rounded()
            let roundedTemperature = Int(temp ?? 0)
            Text("\(roundedTemperature)°")
                .font(.callout.bold())
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 10)
    }
}
