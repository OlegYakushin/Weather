//
//  DetaiIView.swift
//  Weather
//
//  Created by Oleg Yakushin on 4/8/24.
//

import SwiftUI
import CoreLocation
import WeatherKit

struct DetaiIView: View {
    @StateObject var viewModel = WeatherViewModel()
    @State var locationManager = CLLocationManager()
    @ObservedObject var сitiesModel = CityManager()
    let weatherService = WeatherService()
    var city: String
    var latitude = 51.5074
    var longitude = -0.1278
    @AppStorage("temperatureUnit") var temperatureUnit: String = "celsius"
    var body: some View {
    
        RoundedRectangle(cornerRadius: 20 * sizeScreenIphone())
            .frame(width: 350 * sizeScreenIphone(), height: 100 * sizeScreenIphone())
            .foregroundColor(.clear)
            .overlay(
                ZStack{
                    if viewModel.currentWeather?.condition.description == "Clear" {
                        BackgroundView(weatherType: .sunny)
                            .cornerRadius(20 * sizeScreenIphone())
                    } else {
                        BackgroundView(weatherType: .cloudy)
                            .cornerRadius(20 * sizeScreenIphone())
                    }
                    VStack{
                        HStack{
                            VStack(alignment: .leading) {
                                Text(viewModel.cityName)
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .bold()
                            }
                            Spacer()
                            let temp = viewModel.currentWeather?.temperature.converted(to: temperatureUnit == "celsius" ? .celsius : .fahrenheit).value.rounded()
                            let roundedTemperature = Int(temp ?? 0)
                            Text("\(roundedTemperature)°")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .bold()
                        }
                        Spacer()
                        HStack{
                            Text(viewModel.currentWeather?.condition.description ?? "---")
                                .foregroundColor(.white)
                            Spacer()
                            let tempH = viewModel.todayWeather?.highTemperature.converted(to: temperatureUnit == "celsius" ? .celsius : .fahrenheit).value.rounded()
                            let roundedTemperatureH = Int(tempH ?? 0)
                            let tempL = viewModel.todayWeather?.lowTemperature.converted(to: temperatureUnit == "celsius" ? .celsius : .fahrenheit).value.rounded()
                            let roundedTemperatureL = Int(tempL ?? 0)
                            Text("H: \(roundedTemperatureH)°  L: \(roundedTemperatureL)°")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                }
            )
            .onAppear(perform: {
               locationManager.delegate = viewModel
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let location = CLLocation(coordinate: coordinate, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
                locationManager.delegate?.locationManager?(locationManager, didUpdateLocations: [location])
           
            })
    }
    func fetchTemperature(for location: CLLocation) async throws -> Double {
        do {
            let weather = try await weatherService.weather(for: location)
            return weather.currentWeather.humidity
        } catch {
            throw error
        }
    }
    

}

#Preview {
    DetaiIView(city: "Madrid")
}
