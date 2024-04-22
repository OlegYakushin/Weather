//
//  MainView.swift
//  Weather
//
//  Created by Oleg Yakushin on 4/8/24.
//

import SwiftUI
import CoreLocation
import WeatherKit
import MapKit

struct MainView: View {
    @State private var isDetailExpanded = false
    @StateObject var viewModel = WeatherViewModel()
    @ObservedObject var сitiesModel = CityManager()
    @State var locationManager = CLLocationManager()
    @State private var searchResults: ArraySlice<MKMapItem> = []
    @State private var searchText = ""
    let maxResults = 5
    @State private var isSettingsMenuVisible = false
    @State private var  isEditing = false
    @AppStorage("temperatureUnit") var temperatureUnit: String = "celsius"
    let citiesList = [
        City(cityName: "New York", location: CLLocation(latitude: 40.7128, longitude: -74.0060)),
        City(cityName: "London", location: CLLocation(latitude: 40.7128, longitude: -74.0060)),
        City(cityName: "Paris", location: CLLocation(latitude: 40.7128, longitude: -74.0060)),
        City(cityName: "Berlin", location: CLLocation(latitude: 40.7128, longitude: -74.0060)),
        City(cityName: "Madrid", location: CLLocation(latitude: 40.7128, longitude: -74.0060)),
        ]
    init() {
     // Large Navigation Title
     UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]

     // Inline Navigation Title
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
   }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
    
                ScrollView {
                    VStack {
                        
                        ZStack{
                            HStack {
                                Spacer()
                                if  isEditing {
                                    Text("Done")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            withAnimation{
                                                isEditing.toggle()
                                            }
                                        }
                                }else{
                                    Image(systemName: "ellipsis.circle")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .onTapGesture {
                                            withAnimation{
                                                isSettingsMenuVisible.toggle()
                                            }
                                        }
                                }
                            }
                            .padding(.top, 50 * sizeScreenIphone())
                        
                            
                            
                        }
                        HStack {
                                              Text("Weather")
                                                  .font(.largeTitle)
                                                  .bold()
                                                  .foregroundColor(.white)
                                              Spacer()
                                          }
                                          .padding()
                            RoundedRectangle(cornerRadius: 10 * sizeScreenIphone())
                                .foregroundColor(Color.gray.opacity(0.2))
                                .frame(width: 350 * sizeScreenIphone(), height: 40 * sizeScreenIphone())
                                .overlay(
                                    HStack {
                                        TextField("Search", text: $searchText)
                                            .padding(.horizontal)
                                            .foregroundColor(.white)
                                        Button(action: {
                                            searchText = ""
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.white)
                                                .padding(.trailing, 8 * sizeScreenIphone())
                                        }
                                    }
                                )
                        
                        .padding()
                      
                        ScrollView {
                            if searchText == "" {
                                ForEach(сitiesModel.cities?.cities ?? [], id: \.cityName) { city in
                                    if isEditing {
                                      
                                    } else {
                                        
                                        let selection = city.cityName.hashValue
                                        NavigationLink(destination:
                                                        StackWeatherView(selection: selection, сitiesModel: сitiesModel).navigationBarBackButtonHidden()) {
                                            DetaiIView(city: city.cityName, latitude: city.location.coordinate.latitude, longitude: city.location.coordinate.longitude)
                                        }
                                                        .onTapGesture {
                                                            withAnimation {
                                                                isDetailExpanded.toggle()
                                                            }
                                                        }
                                                        .scaleEffect(isDetailExpanded ? 1.1 : 1.0)
                                                        .opacity(isDetailExpanded ? 0.5 : 1.0)
                                                        .offset(y: isDetailExpanded ? -20 : 0)
                                                      
                                                    
                                        .contextMenu {
                                            Button(action: {
                                                сitiesModel.deleteCity(city)
                                            }) {
                                                Text("Delete")
                                                Image(systemName: "trash")
                                            }
                                        }
                                    }
                                    
                                    
                                }
                            } else {
                                ForEach(searchResults.prefix(maxResults), id: \.name) { mapItem in
                                    if let name = mapItem.name,
                                       let location = mapItem.placemark.location {
                                        NavigationLink(destination: NewWeatherView(сitiesModel: сitiesModel, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, topEdge: 8).navigationBarBackButtonHidden()) {
                                            Text(name)
                                                .foregroundColor(.white)
                                        }
                                    } else {
                                        Text("Unknown Location")
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                    }
                }
                    .ignoresSafeArea()
                 // .navigationTitle("Weather")
                if isSettingsMenuVisible {
                    RoundedRectangle(cornerRadius: 10 * sizeScreenIphone())
                        .frame(width: 150 * sizeScreenIphone(), height: 220 * sizeScreenIphone())
                        .foregroundColor(.black.opacity(0.9))
                        .overlay(
                            VStack {
                                Button(action: {
                                    withAnimation{
                                        isEditing.toggle()
                                        isSettingsMenuVisible.toggle()
                                    }
                                }) {
                                    
                                    HStack{
                                        Text("Edit List")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: "arrow.up.arrow.down")
                                            .foregroundColor(.white)
                                        
                                    }
                                    .padding()
                                    
                                }
                                Button(action: {
                                    temperatureUnit = "celsius"
                                    withAnimation{
                                        isSettingsMenuVisible.toggle()
                                    }
                                }) {
                                    
                                    HStack{
                                        Text("Celsius")
                                            .foregroundColor(.white)
                                        Spacer()
                                        if temperatureUnit == "celsius" {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.white)
                                        }
                                        
                                    }
                                    .padding()
                                    
                                }
                                Button(action: {
                                    temperatureUnit = "fahrenheit"
                                    withAnimation{
                                        isSettingsMenuVisible.toggle()
                                    }
                                }) {
                                    
                                    HStack{
                                        Text("Fahrenheit")
                                            .foregroundColor(.white)
                                        Spacer()
                                        if temperatureUnit == "fahrenheit" {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.white)
                                        }
                                        
                                    }
                                    .padding()
                                    
                                }
                                Button(action: {
                                  
                                }) {
                                    
                                    HStack{
                                        Text("Feedback")
                                            .foregroundColor(.white)
                                        Spacer()
                                       
                                        
                                    }
                                    .padding()
                                    
                                }
                            }
                        )
                        .offset(x: 120 * sizeScreenIphone(), y: -240 * sizeScreenIphone())
                }
                    
                }
            }
        
            .onAppear {
                searchText = ""
            
        }
        
        .onAppear(perform: {
            locationManager.delegate = viewModel
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        })
        .onAppear {
            сitiesModel.loadCity()
            searchText = ""
        }
        .onChange(of: searchText) { _ in
            searchCities()
        }
      
    }
    
    func searchCities() {
            if searchText.isEmpty {
                self.searchResults = []
                return
            }
            let filteredCities = citiesList.filter { city in
                return city.cityName.lowercased().contains(searchText.lowercased())
            }
            
            let mapItems = filteredCities.map { city in
                MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: city.location.coordinate.latitude, longitude: city.location.coordinate.longitude)))
            }
            self.searchResults = ArraySlice(mapItems.prefix(maxResults))
        }

    func moveCity(from source: IndexSet, to destination: Int) {
          guard var cities = сitiesModel.cities?.cities else { return }
          cities.move(fromOffsets: source, toOffset: destination)
          сitiesModel.cities?.cities = cities
          сitiesModel.saveCity()
      }
}


#Preview {
    MainView()
}
