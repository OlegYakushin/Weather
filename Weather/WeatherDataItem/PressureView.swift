//
//  PressureView.swift
//  Weather
//
//  Created by Oleg Yakushin on 4/13/24.
//

import SwiftUI
import WeatherKit

struct PressureView: View {
    var currentWeather: CurrentWeather
    
    var body: some View {
        CustomStackView {
            Label {
                Text("Pressure".uppercased())
            } icon: {
                Image(systemName: "sun.dust")
            }
            
        } contentView: {
            
            VStack(alignment: .leading, spacing: 10) {
                Text(Int(currentWeather.pressure.value).formatted())
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text(currentWeather.pressure.value > 1000 ? "High" : "Low")
                    .font(.callout)
                    .fontWeight(.regular)

            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .leading)
        }
    }
}
