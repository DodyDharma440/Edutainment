//
//  MainView.swift
//  Edutainment
//
//  Created by Dodi Aditya on 22/09/23.
//

import SwiftUI

private struct SettingsTitle: View {
    var title: String
    var isAnimated: Bool
    
    var body: some View {
        Text(title)
            .foregroundColor(.white)
            .font(.title)
            .fontWeight(.semibold)
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : -10)
            .animation(.easeIn, value: isAnimated)
    }
}

private struct ButtonOptionLabel: View {
    var label: String
    var isActive: Bool = false
    var isAnimated: Bool
    
    var body: some View {
        Text("\(label)")
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(!isActive ? .white : .orange)
            .cornerRadius(6)
            .font(.title3)
            .foregroundColor(isActive ? .white : .orange)
            .fontWeight(.semibold)
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : -10)
    }
}

struct MainView: View {
    static var countOptions = [5, 10, 20]
    
    @EnvironmentObject var contentVm: ContentViewModel
    
    @State private var isAnimated = false
    
    var body: some View {
        VStack(spacing: 50) {
            Spacer()
                .frame(height: 10)
            
            VStack(alignment: .leading) {
                SettingsTitle(
                    title: "Select Multiplication",
                    isAnimated: isAnimated
                )
                
                LazyVGrid(columns: makeColumns(count: 6), spacing: 6) {
                    ForEach(1..<13) { num in
                        let isSelected = num == contentVm.multiplication
                        
                        Button {
                            contentVm.multiplication = num
                        } label: {
                            ButtonOptionLabel(
                                label: "\(num)",
                                isActive: isSelected,
                                isAnimated: isAnimated
                            )
                            .animation(.default.delay(Double(num) / 15), value: isAnimated)
                        }
                    } // Loop
                } // Grid
            } // VStack
            
            VStack(alignment: .leading) {
                SettingsTitle(
                    title: "Questions to Answer",
                    isAnimated: isAnimated
                )
                
                LazyVGrid(columns: makeColumns(count: 3), spacing: 6) {
                    ForEach(MainView.countOptions.indices, id: \.self) { index in
                        let num = MainView.countOptions[index]
                        let isSelected = num == contentVm.questionCount
                        
                        Button {
                            contentVm.questionCount = num
                        } label: {
                            ButtonOptionLabel(
                                label: "\(num)",
                                isActive: isSelected,
                                isAnimated: isAnimated
                            )
                            .animation(.default.delay(Double(index + 1) / 8), value: isAnimated)
                        }
                    } // Loop
                } // Grid
            } // VStack
            
            Button {
                isAnimated = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        contentVm.isAnswering = true
                    }
                }
            } label: {
                Text("Start Game")
                    .padding(.horizontal, 24)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(.green.opacity(0.8))
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .cornerRadius(8)
                    .opacity(isAnimated ? 1 : 0)
                    .animation(.default.delay(0.8), value: isAnimated)
            }
            
            Spacer()
        } // VStack
        .onAppear {
            isAnimated = true
        }
    }
    
    func makeColumns(count: Int) -> [GridItem] {
        Array(repeating: GridItem(.flexible()), count: count)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainBackgroundView {
            MainView()
                .environmentObject(ContentViewModel())
        }
    }
}
