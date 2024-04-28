//
//  TabBar.swift
//  Weather
//
//  Created by Oleg Yakushin on 4/28/24.
//

import SwiftUI

struct TabBar: View {
    var action: () -> Void
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Image(systemName: "list.star")
                    .frame(width: 44, height: 44)
                    .onTapGesture {
                        action()
                    }
            }
        }
    }
}

#Preview {
    TabBar(action: {})
}
