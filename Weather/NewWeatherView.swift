//
//  NewWeatherView.swift
//  Weather
//
//  Created by Oleg Yakushin on 4/12/24.
//

import SwiftUI
import CoreLocation
import WeatherKit

struct NewWeatherView: View {
    @StateObject var viewModel = WeatherViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var locationManager = CLLocationManager()
    @ObservedObject var сitiesModel: CityManager
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
                ZStack{
                    Text(viewModel.cityName)
                        .font(.system(size: 35))
                        .foregroundStyle(.white)
                        .shadow(radius: 5)
                        .padding(.top, 15)
                    HStack {
                        Spacer()
                        Text("Add")
                            .font(.system(size: 20))
                            .foregroundStyle(.white.opacity(opacity))
                            .shadow(radius: 5)
                            .onTapGesture {
                                сitiesModel.addCity(cityName: viewModel.cityName, latitude: latitude, longitude: longitude)
                                opacity = 0
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                    .padding(.horizontal)
                }
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
                       // .offset(y: -offset)
                     //   .offset(y: offset > 0 ? (offset / UIScreen.main.bounds.width) * 100 : 0)
                      //  .offset(y: getTitleOffset())
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
                .padding(.top, 15)
            }
        }
        .gesture(DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
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
