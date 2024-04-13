//
//  WindView.swift
//  Weather
//
//  Created by Oleg Yakushin on 4/13/24.
//

import SwiftUI
import WeatherKit

struct WindView: View {
    var wind: Wind?
    
    var body: some View {
        CustomStackView {
            Label {
                Text("WIND")
            } icon: {
                Image(systemName: "wind")
            }
            
        } contentView: {
            
            VStack(alignment: .leading, spacing: 10) {
                Text(wind?.speed.formatted() ?? "-")
                    .font(.title)
                    .fontWeight(.semibold)
                
                HStack {
                    Text(wind?.direction.formatted() ?? "-")
                        .font(.callout)
                        .fontWeight(.regular)
                    Text(wind?.compassDirection.description ?? "-")
                        .font(.callout)
                        .fontWeight(.regular)
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .leading)
        }
    }
}
