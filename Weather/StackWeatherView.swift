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
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onAppear {
                сitiesModel.loadCity()
            }
            VStack {
                Spacer()
                ZStack{
                        HStack(spacing: 8) {
                            ForEach(сitiesModel.cities?.cities ?? [], id: \.cityName) { city in
                                Circle()
                                    .fill(city.cityName.hashValue == selection ? Color.white : Color.gray)
                                    .frame(width: 8, height: 8)
                            }
                        }
                        HStack {
                            Spacer()
                            Image(systemName: "list.star")
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .onTapGesture {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                    }
                        .padding(.horizontal, 10)
                }
                .padding(.bottom, 20)
                .background(BlurView(style: .light))
            }
            .ignoresSafeArea()
        }
        
    }
}



struct BlurView: UIViewRepresentable {

    let style: UIBlurEffect.Style

    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }

    func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<BlurView>) {

    }

}
