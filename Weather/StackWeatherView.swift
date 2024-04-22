//
//  StackWeatherView.swift
//  Weather
//
//  Created by Oleg Yakushin on 4/18/24.
//

import SwiftUI

struct StackWeatherView: View {
   @State var selection: Int
    @ObservedObject var сitiesModel = CityManager()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                ForEach(сitiesModel.cities?.cities ?? [], id: \.cityName) { city in
                    WeatherView(latitude: city.location.coordinate.latitude, longitude: city.location.coordinate.longitude, topEdge: 0)
                        .tag(city.cityName.hashValue)
                        .padding(.top, -15)
                    
                }
                
            }
            .edgesIgnoringSafeArea(.top)
            .ignoresSafeArea()
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .onAppear {
                сitiesModel.loadCity()
            }
            VStack {
                            HStack {
                              
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "arrow.left")
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }
                Spacer()
                           
                        }
            .padding(30)
      
        }
        
    }
}




