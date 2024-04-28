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
import NavigationTransition

struct MainView: View {
    @State private var isDetailExpanded = false
    @StateObject var viewModel = WeatherViewModel()
    @ObservedObject var сitiesModel = CityManager()
    @State var locationManager = CLLocationManager()
    @State private var searchResults: [City] = []
    @State private var searchText = ""
    let maxResults = 5
    @State private var isSettingsMenuVisible = false
    @State private var  isEditing = false
    @State private var  isPopoverPresented = false
    @AppStorage("temperatureUnit") var temperatureUnit: String = "celsius"
    @State var offset: CGFloat = 0
    @State var startOffset: CGFloat = 0
    @State var titleOffset: CGFloat = 0
    @State private var  changeTitle = false
    let citiesList = [
        City(cityName: "New York", location: CLLocation(latitude: 40.7128, longitude: -74.0060)),
        City(cityName: "London", location: CLLocation(latitude: 51.5074, longitude: -0.1278)),
        City(cityName: "Paris", location: CLLocation(latitude: 48.8566, longitude: 2.3522)),
        City(cityName: "Berlin", location: CLLocation(latitude: 52.5200, longitude: 13.4050)),
        City(cityName: "Madrid", location: CLLocation(latitude: 40.4168, longitude: -3.7038)),
    ]
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                ZStack {
                    if isEditing {
                       List {
                            ForEach(сitiesModel.cities?.cities ?? [], id: \.cityName) { city in
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
                            }
                            .onMove(perform: moveCity)
                        }
                        .listRowBackground(Color.clear)
                        .listStyle(PlainListStyle())
                        .padding(.top, 190 * sizeScreenIphone())
                        
                    } else {
                        
                        ScrollView(showsIndicators: false) {
                            VStack {
                                if searchText == "" {
                                    ForEach(сitiesModel.cities?.cities ?? [], id: \.cityName) { city in
                                        
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
                                else {
                                    VStack {
                                        ForEach(searchResults.prefix(maxResults), id: \.cityName) { city in
                                            if city.cityName != nil {
                                                    Text(city.cityName)
                                                        .foregroundColor(.white)
                                                        .onTapGesture {
                                                            isPopoverPresented.toggle()
                                                        }
                                                        .popover(isPresented: $isPopoverPresented, arrowEdge: .top) {
                                                            // Content of the popover
                                                            NewWeatherView(сitiesModel: сitiesModel, latitude: city.location.coordinate.latitude, longitude: city.location.coordinate.longitude, topEdge: 8)
                                                                .navigationBarBackButtonHidden()
                                                                .onDisappear{
                                                                    searchText = ""
                                                                }
                                                        }

                                                
                                            } else {
                                                Text("Unknown Location")
                                                    .foregroundColor(.white)
                                            }
                                                                                        }
                                    }
                                    .padding(.top, 10)
                                    
                                }
                                
                            }
                            .padding(.top, 190 * sizeScreenIphone())
                            .overlay(
                                GeometryReader{ proxy -> Color in
                                    let minY = proxy.frame(in: .global).minY
                                    DispatchQueue.main.async {
                                        self.offset = minY
                                        if startOffset == 0 {
                                            startOffset = minY
                                        }else{
                                            offset = startOffset - minY
                                            if offset >  0 * sizeScreenIphone() {
                                                withAnimation {
                                                    changeTitle = true
                                                }
                                            } else {
                                                withAnimation {
                                                    changeTitle = false
                                                }
                                            }
                                            print(offset)
                                        }
                                        
                                    }
                                    return Color.clear
                                    
                                }
                                    .frame(width: 0, height: 0)
                                ,alignment: .top
                            )
                        }
                    }
                    VStack{
                        VStack{
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
                                .padding(.horizontal, 10 * sizeScreenIphone())
                                
                                
                                
                            }
                            if changeTitle == false {
                                HStack {
                                    Text("Weather")
                                        .font(.largeTitle)
                                        .bold()
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(.horizontal, 20 * sizeScreenIphone())
                            } else {
                                HStack {
                                    Text("Weather")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 20 * sizeScreenIphone())
                                .padding(.top, -20 * sizeScreenIphone())
                                
                            }
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
                                .padding(3)
                                .padding(.bottom, 15)
                            
                        }
                        .background(BlurView(style: .dark))
                        Spacer()
                    }
                    
                }
                .ignoresSafeArea()
                
                if isSettingsMenuVisible {
                    RoundedRectangle(cornerRadius: 10 * sizeScreenIphone())
                        .frame(width: 150 * sizeScreenIphone(), height: 220 * sizeScreenIphone())
                        .foregroundColor(.black.opacity(0.1))
                        .overlay(BlurView(style: .dark))
                        .cornerRadius(10 * sizeScreenIphone())
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
                                    // add action
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
        
        self.searchResults = Array(filteredCities.prefix(maxResults))
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
