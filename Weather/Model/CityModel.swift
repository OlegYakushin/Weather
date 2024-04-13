//
//  CityModel.swift
//  Weather
//
//  Created by Oleg Yakushin on 4/12/24.
//

import Foundation
import CoreLocation

struct CityModel: Codable {
    var cities: [City]
}
struct City: Codable, Equatable {
    var cityName: String
    var location: CLLocation
    static func == (lhs: City, rhs: City) -> Bool {
          return lhs.cityName == rhs.cityName && lhs.location == rhs.location
      }
    enum CodingKeys: String, CodingKey {
        case cityName
        case latitude
        case longitude
    }

    init(cityName: String, location: CLLocation) {
        self.cityName = cityName
        self.location = location
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cityName = try container.decode(String.self, forKey: .cityName)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        location = CLLocation(latitude: latitude, longitude: longitude)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cityName, forKey: .cityName)
        try container.encode(location.coordinate.latitude, forKey: .latitude)
        try container.encode(location.coordinate.longitude, forKey: .longitude)
    }
}

class CityManager: ObservableObject {
    @Published var cities: CityModel?

    init() {
        loadCity()
        if cities == nil {
                   initializeCity()
               }
       }
    func deleteCity(_ city: City) {
        if let index = cities?.cities.firstIndex(where: { $0.cityName == city.cityName }) {
            cities?.cities.remove(at: index)
            saveCity()
        }
    }
    func saveCity() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cities) {
            UserDefaults.standard.set(encoded, forKey: "cities")
        }
    }
    func addCity(cityName: String, latitude: Double, longitude: Double) {
            let newCity = City(cityName: cityName, location: CLLocation(latitude: latitude, longitude: longitude))
            cities?.cities.append(newCity)
            saveCity()
        }
    func loadCity() {
        if let data = UserDefaults.standard.data(forKey: "cities") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(CityModel.self, from: data) {
                cities = decoded
            }
        }
    }
    private func initializeCity() {
        let city1 = City(cityName: "New York", location: CLLocation(latitude: 40.7128, longitude: -74.0060))
        let city2 = City(cityName: "London", location: CLLocation(latitude: 51.5074, longitude: -0.1278))
        let city3 = City(cityName: "Tokyo", location: CLLocation(latitude: 35.6895, longitude: 139.6917))

        let cityModel = CityModel(cities: [city1, city2, city3])
        self.cities = cityModel
        saveCity()
    }

}

