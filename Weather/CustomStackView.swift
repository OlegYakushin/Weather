//
//  CustomStackView.swift
//  Weather
//
//  Created by Oleg Yakushin on 4/9/24.
//

import SwiftUI

struct CustomStackView<Title: View, Content: View>: View {
    var titleView: Title
    var contentView: Content
    
    @State private var topOffset: CGFloat = 0
    @State private var bottomOffset: CGFloat = 0
    
    init(@ViewBuilder titleView: @escaping () -> Title,
         @ViewBuilder contentView: @escaping () -> Content) {
        self.contentView = contentView()
        self.titleView = titleView()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            titleView
                .font(.callout)
                .lineLimit(1)
                .frame(height: 38)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .background(
                    .ultraThinMaterial,
                    in: CustomCorner(corners: bottomOffset < 38 ? .allCorners : [.topLeft, .topRight], radius: 12)
                )
                .zIndex(1)
            
            VStack {
                Divider()
                contentView.padding()
            }
            .background(
                .ultraThinMaterial,
                in: CustomCorner(corners: [.bottomLeft, .bottomRight], radius: 12)
            )
            .offset(y: topOffset >= 120 ? 0 : -(-topOffset + 120))
            .zIndex(0)
            .clipped()
            .opacity(getOpacity())
        }
        .colorScheme(.dark)
        .cornerRadius(12)
        .opacity(getOpacity())
        .offset(y: topOffset >= 120 ? 0 : -topOffset + 120)
        .background(
            GeometryReader { proxy -> Color in
                    let minY = proxy.frame(in: .global).minY
                    let maxY = proxy.frame(in: .global).maxY
                
                DispatchQueue.main.async {
                    withAnimation( (.easeInOut(duration: 0.05))) {
                        self.topOffset = minY
                        self.bottomOffset = maxY - 120
                    }
                }
                
                return Color.clear
            }
        )
        .modifier(CornerModifier(bottomOffset: $bottomOffset))
    }
    
    private func getOpacity() -> CGFloat {
        if bottomOffset < 28 {
            return bottomOffset / 28
        }
        return 1
    }
}

struct CustomStackView_Previews: PreviewProvider {
    static var previews: some View {
        CustomStackView {
            Text("Title")
        } contentView: {
            Text("Content")
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

