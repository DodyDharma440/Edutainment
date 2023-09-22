//
//  ContentView.swift
//  Edutainment
//
//  Created by Dodi Aditya on 22/09/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    
    var body: some View {
        MainBackgroundView {
            if vm.isAnswering {
                PlayView()
                    .transition(.opacity)
            } else {
                MainView()
            }
        }
        .environmentObject(vm)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
