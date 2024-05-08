//
//  WeatherView.swift
//  Weather
//
//  Created by Oleg Yakushin on 4/9/24.
//

import SwiftUI
import CoreLocation
import WeatherKit

struct WeatherView: View {
    @StateObject var viewModel = WeatherViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var locationManager = CLLocationManager()
    @State var offset: CGFloat = 0
    var latitude = 51.5074
    var longitude = -0.1278
    @State private var opacity: Double = 1
    @AppStorage("temperatureUnit") var temperatureUnit: String = "celsius"
    var topEdge: CGFloat
    
    var body: some View {
        ZStack {
            if viewModel.currentWeather?.condition.description == "Clear" {
                BackgroundView(weatherType: .sunny)
            } else {
                BackgroundView(weatherType: .cloudy)
            }
            VStack {
                Text(viewModel.cityName)
                    .font(.system(size: 35))
                    .foregroundStyle(.white)
                    .shadow(radius: 5)
                    .padding(.top, 50 * sizeScreenIphone())
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        VStack(alignment: .center, spacing: 5) {
                            ZStack{
                               
                            }
                            if viewModel.cityName == "----" {
                                
                            }else{
                                let temp = viewModel.currentWeather?.temperature.converted(to: temperatureUnit == "celsius" ? .celsius : .fahrenheit).value.rounded()
                                let roundedTemperature = Int(temp ?? 0)
                                Text("\(roundedTemperature)°")
                                    .font(.system(size: 45))
                                    .foregroundStyle(.white)
                                    .shadow(radius: 5)
                                    .opacity(getTitleOpactiy())
                                
                                Text(viewModel.currentWeather?.wind.speed.formatted(.measurement(width: .abbreviated, usage: .general)) ?? "---")
                                    .foregroundStyle(.secondary)
                                    .foregroundStyle(.white)
                                    .shadow(radius: 5)
                                    .opacity(getTitleOpactiy())
                                
                                Text(viewModel.currentWeather?.condition.description ?? "---")
                                    .foregroundStyle(.secondary)
                                    .foregroundStyle(.white)
                                    .shadow(radius: 5)
                                    .opacity(getTitleOpactiy())
                                
                                let tempH = viewModel.todayWeather?.highTemperature.converted(to: temperatureUnit == "celsius" ? .celsius : .fahrenheit).value.rounded()
                                let roundedTemperatureH = Int(tempH ?? 0)
                                let tempL = viewModel.todayWeather?.lowTemperature.converted(to: temperatureUnit == "celsius" ? .celsius : .fahrenheit).value.rounded()
                                let roundedTemperatureL = Int(tempL ?? 0)
                                Text("H: \(roundedTemperatureH)°  L: \(roundedTemperatureL)°")
                                    .foregroundStyle(.primary)
                                    .foregroundStyle(.white)
                                    .shadow(radius: 5)
                                    .opacity(getTitleOpactiy())
                            }
                        }
                        .environmentObject(viewModel)
                        
                        VStack(spacing: 8) {
                            if let forecasts = viewModel.hourlyForecasts {
                                CustomStackView {
                                    Label {
                                        Text("Hourly Forecast")
                                    } icon: {
                                        Image(systemName: "clock")
                                    }
                                } contentView: {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 8) {
                                            ForEach(forecasts, id: \.date) { weather in
                                                HourForecastItemView(hourWeather: weather)
                                            }
                                            
                                        }
                                    }
                                }
                            }
                            if let forecasts = viewModel.dailyForecasts {
                                DailyForecastView(dailyForecast: forecasts)
                            }
                            
                            if let currentWeather = viewModel.currentWeather {
                                WeatherDataView(currentWeather: currentWeather)
                            }
                        }
                        .padding(.top, 20)
                    }
                    .padding(.bottom, 70 * sizeScreenIphone())
                    .padding(.top, topEdge)
                    .padding([.horizontal, .bottom])
                }
            }
        }
        .ignoresSafeArea()
        .onAppear(perform: {
           locationManager.delegate = viewModel
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let location = CLLocation(coordinate: coordinate, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
            locationManager.delegate?.locationManager?(locationManager, didUpdateLocations: [location])
       
        })
    }
    
    private func getTitleOpactiy()->CGFloat{
        
        let titleOffset = -getTitleOffset()
        
        let progress = titleOffset / 20
        
        let opacity = 1 - progress
        
        return opacity
    }
    
    private func getTitleOffset() -> CGFloat {
        if offset < 0 {
            let progress = -offset / 120
            let newOffset = (progress <= 1.0 ? progress : 1) * 20
            return -newOffset
        }
        return 0
    }
}


struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(topEdge: 8)
    }
}

