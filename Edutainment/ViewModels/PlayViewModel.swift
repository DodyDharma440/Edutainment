//
//  PlayViewModel.swift
//  Edutainment
//
//  Created by Dodi Aditya on 22/09/23.
//

import Foundation

class PlayViewModel: ObservableObject {
    @Published var currentQuestion = 0
    @Published var multipler = 0
    
    @Published var correctAnswer = 0
    @Published var answerOptions = [Int()]
    @Published var score = 0
    
    @Published var isCorrect: Bool? = nil
    @Published var answer: Int? = nil
    
    @Published var isShowResult = false
    
    private func generateAnswer(currentOptions: [Int]) -> Int {
        let incorrectAnswers = [
            correctAnswer + 1,
            correctAnswer - 1,
            correctAnswer * 2,
            correctAnswer / 2,
            correctAnswer + Int.random(in: 1...10) + 1,
            correctAnswer - Int.random(in: 1...10) - 1,
        ]
        
        let index = Int.random(in: 0..<incorrectAnswers.count)
        let answer = incorrectAnswers[index]
        let isExist = currentOptions.contains(answer)
        
        if isExist {
            return generateAnswer(currentOptions: currentOptions)
        }
        return answer
    }
    
    func generateQuestion(multipler multiplication: Int) {
        multipler = Int.random(in: 1...12)
        correctAnswer = multiplication * multipler
        currentQuestion += 1
        isCorrect = nil
        answer = nil
        
        var options = [Int]()
        for _ in 0..<3 {
            let answer = generateAnswer(currentOptions: options)
            
            options.insert(answer, at: options.count)
        }
        options.insert(correctAnswer, at: 0)
        answerOptions = options.shuffled()
    }
    
    func finish() {
        isShowResult = true
    }
    
    func handleAnswer(_ value: Int) {
        answer = value
        isCorrect = value == correctAnswer
        
        if value == correctAnswer {
            score += 1
        }
    }
}
