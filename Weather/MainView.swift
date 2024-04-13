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
    @StateObject var viewModel = WeatherViewModel()
    @ObservedObject var сitiesModel = CityManager()
    @State var locationManager = CLLocationManager()
    @State private var searchResults: ArraySlice<MKMapItem> = []
    @State private var searchText = ""
    let maxResults = 5
    @State private var isSettingsMenuVisible = false
    @State private var  isEditing = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
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
                        if isSettingsMenuVisible {
                            RoundedRectangle(cornerRadius: 10 * sizeScreenIphone())
                                .frame(width: 150 * sizeScreenIphone(), height: 50 * sizeScreenIphone())
                                .foregroundColor(.gray.opacity(0.5))
                                .overlay(
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
                                )
                                .offset(x: 120 * sizeScreenIphone(), y: 70 * sizeScreenIphone())
                        }
                         

                    }
                    HStack {
                        Text("Weather")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    ZStack {
                        RoundedRectangle(cornerRadius: 10 * sizeScreenIphone())
                            .foregroundColor(Color.gray.opacity(0.8))
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
                    }
                    .padding()
                    /*    ScrollView(showsIndicators: false) {
                        if searchText == "" {
                            NavigationLink(destination: WeatherView(latitude:(locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, topEdge: 8).navigationBarBackButtonHidden()) {
                                DetaiIView(city: "", latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
                            }
                            
                            ForEach(сitiesModel.cities?.cities ?? [], id: \.cityName) { city in
                                if isEditing {
                                    HStack{
                                        DetaiIView(city: city.cityName, latitude: city.location.coordinate.latitude, longitude: city.location.coordinate.longitude)
                                            .scaleEffect(0.8)
                                        Image(systemName: "line.3.horizontal")
                                            .foregroundColor(.white)
                                    }
                                    .onTapGesture {
                                        guard isEditing else { return }
                                        guard let currentIndex = сitiesModel.cities?.cities.firstIndex(of: city) else { return }
                                        let newIndex = currentIndex == 0 ? 0 : currentIndex - 1 // Перемещаем вверх по списку
                                        if let cities = сitiesModel.cities {
                                            var newCities = cities.cities
                                            newCities.move(fromOffsets: IndexSet(integer: currentIndex), toOffset: newIndex)
                                            сitiesModel.cities?.cities = newCities
                                            сitiesModel.saveCity()
                                        }
                                    }
                                    } else {
                                        NavigationLink(destination: WeatherView(latitude: city.location.coordinate.latitude, longitude: city.location.coordinate.longitude, topEdge: 8).navigationBarBackButtonHidden()) {
                                            DetaiIView(city: city.cityName, latitude: city.location.coordinate.latitude, longitude: city.location.coordinate.longitude)
                                        }
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
                    } */
                    List {
                        if searchText == "" {
                            NavigationLink(destination: WeatherView(latitude:(locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, topEdge: 8).navigationBarBackButtonHidden()) {
                                DetaiIView(city: "", latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
                            }
                            .listRowBackground(Color.clear)
                            ForEach(сitiesModel.cities?.cities ?? [], id: \.cityName) { city in
                                if isEditing {
                                    HStack {
                                        Text(city.cityName)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: "line.3.horizontal")
                                            .foregroundColor(.white)
                                            .padding(.trailing)
                                    }
                                    .listRowBackground(Color.clear)
                                    .padding()
                                    .background(Color.blue.opacity(0.8))
                                    .cornerRadius(10 * sizeScreenIphone())
                                } else {
                                    NavigationLink(destination: WeatherView(latitude: city.location.coordinate.latitude, longitude: city.location.coordinate.longitude, topEdge: 8).navigationBarBackButtonHidden()) {
                                        DetaiIView(city: city.cityName, latitude: city.location.coordinate.latitude, longitude: city.location.coordinate.longitude)
                                        
                                    }
                                    .listRowBackground(Color.clear)
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
                            .onMove(perform: moveCity)
                        } else {
                            ForEach(searchResults.prefix(maxResults), id: \.name) { mapItem in
                                if let name = mapItem.name,
                                   let location = mapItem.placemark.location {
                                    NavigationLink(destination: NewWeatherView(сitiesModel: сitiesModel, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, topEdge: 8).navigationBarBackButtonHidden()) {
                                        Text(name)
                                            .foregroundColor(.white)
                                    }
                                    .listRowBackground(Color.clear)
                                } else {
                                    Text("Unknown Location")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
              
                }
                .ignoresSafeArea()
            }
            .onAppear {
                searchText = ""
            }
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
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("\(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.searchResults = response.mapItems.prefix(maxResults)
        }
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
