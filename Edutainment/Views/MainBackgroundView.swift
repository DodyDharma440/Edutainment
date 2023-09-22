//
//  MainBackgroundView.swift
//  Edutainment
//
//  Created by Dodi Aditya on 22/09/23.
//

import SwiftUI

struct MainBackgroundView<Content: View>: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.orange, Color.yellow],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            .opacity(0.8)
            .ignoresSafeArea()
            
            content()
                .padding()
        }
        .foregroundColor(.white)
    }
}

struct MainBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        MainBackgroundView {
            Text("Content")
        }
    }
}
