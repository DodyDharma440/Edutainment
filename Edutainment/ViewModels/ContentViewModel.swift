//
//  ContentViewModel.swift
//  Edutainment
//
//  Created by Dodi Aditya on 22/09/23.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var multiplication = 2
    @Published var questionCount = 5
    @Published var isAnswering = false
    
    func reset() {
        multiplication = 2
        questionCount = 5
        isAnswering = false
    }
}
