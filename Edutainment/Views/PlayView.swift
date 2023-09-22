//
//  PlayView.swift
//  Edutainment
//
//  Created by Dodi Aditya on 22/09/23.
//

import SwiftUI

private struct ListItem: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.semibold)
            Spacer()
            Text(value)
        }
        .font(.title2)
    }
}

struct PlayView: View {
    @EnvironmentObject var contentVm: ContentViewModel
    @StateObject var playVm = PlayViewModel()
    
    @State private var isShowQuit = false
    @State private var nextButtonClicked = false
    
    @State private var nextButtonAnimated = false
    
    var isLastQuestion: Bool {
        playVm.currentQuestion >= contentVm.questionCount
    }
    
    var percentage: Double {
        (Double(playVm.score) / Double(contentVm.questionCount)) * 100
    }
    
    var body: some View {
        ZStack {
            if !playVm.isShowResult {
                VStack {
                    HStack {
                        Button("Stop") {
                            isShowQuit = true
                        }
                        .tint(.white)
                        
                        Spacer()
                        
                        Text("Question \(playVm.currentQuestion)/\(contentVm.questionCount)")
                    }
                    
                    VStack(spacing: 10) {
                        VStack(alignment: .trailing, spacing: 20) {
                            Text("\(contentVm.multiplication)")
                            HStack(alignment: .bottom, spacing: 40) {
                                Text("X")
                                    .font(.system(size: 60))
                                    .padding(.bottom, 6)
                                
                                Text("\(playVm.multipler)")
                            }
                        }
                        .font(.system(size: 80))
                        .padding(.top, 24)
                        .bold()
                        
                        RoundedRectangle(cornerRadius: 6)
                            .frame(width: 280, height: 6)
                    }
                    
                    VStack(spacing: 20) {
                        Text("Pick the correct answer")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            ForEach(playVm.answerOptions, id: \.self) { option in
                                let isUserAnswer = playVm.answer == option
                                let isIncorrect = isUserAnswer && !(playVm.isCorrect ?? false)
                                
                                let isCorrect = (playVm.isCorrect != nil && playVm.correctAnswer == option)
                                
                                Button {
                                    withAnimation {
                                        nextButtonClicked = false
                                    }
                                    playVm.handleAnswer(option)
                                } label: {
                                    Text("\(option)")
                                        .padding(.vertical, 12)
                                        .padding(.horizontal)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            isCorrect ? .green : isIncorrect ? .red : .white.opacity(0.8)
                                        )
                                        .cornerRadius(8)
                                        .foregroundColor(isCorrect || isIncorrect ? .white : .orange)
                                        .font(.title)
                                        .bold()
                                }
                            } // Loop
                        } // VStack
                        .padding(.horizontal)
                    } // VStack
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    if let isCorrect = playVm.isCorrect {
                        VStack {
                            Text(isCorrect ? "Correct!" : "Wrong answer. The correct answer is \(playVm.correctAnswer)")
                                .bold()
                                .opacity(nextButtonAnimated ? 1 : 0)
                                .animation(.default, value: nextButtonAnimated)
                            
                            Button {
                                if !nextButtonClicked {
                                    nextButtonAnimated = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                        withAnimation {
                                            nextButtonClicked = true
                                            
                                            if isLastQuestion {
                                                playVm.finish()
                                            } else {
                                                playVm.generateQuestion(multipler: contentVm.multiplication)
                                            }
                                        }
                                    }
                                }
                            } label: {
                                Text(isLastQuestion ? "Finish" : "Next Question")
                                    .padding(.horizontal, 24)
                                    .padding(.vertical)
                                    .frame(maxWidth: .infinity)
                                    .background(.orange)
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .cornerRadius(8)
                            }
                            .offset(y: nextButtonAnimated ? 0 : 150)
                            .animation(.spring(), value: nextButtonAnimated)
                        } // VStack
                        .padding(.horizontal)
                        .onAppear {
                            nextButtonAnimated = true
                        }
                    }
                }
                .alert("Stop Game", isPresented: $isShowQuit) {
                    Button("Cancel", role: .cancel) {}
                    Button("Yes, stop current game", role: .destructive) {
                        contentVm.reset()
                    }
                } message: {
                    Text("Are you sure to stop the current game? All progress and score will be lost.")
                }
            } else {
                VStack {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Text("Scoreboard")
                            .fontWeight(.semibold)
                        Text("\(percentage.formatted())%")
                            .bold()
                    }
                    .font(.system(size: 40))
                    
                    VStack {
                        ListItem(label: "Questions", value: "\(contentVm.questionCount)")
                        
                        Divider()
                            .frame(height: 2)
                            .overlay(.white)
                        
                        ListItem(label: "Correct", value: "\(playVm.score)")
                        
                        Divider()
                            .frame(height: 2)
                            .overlay(.white)
                        
                        ListItem(label: "Wrong", value: "\(contentVm.questionCount - playVm.score)")
                    } // VStack
                    .padding()
                    .background(.white.opacity(0.2))
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    Button {
                        contentVm.reset()
                    } label: {
                        Text("Play Again")
                            .padding(.horizontal, 24)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(.green.opacity(0.8))
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .cornerRadius(8)
                    }
                } // VStack
            } // Condition
        } // ZStack
        .onAppear {
            playVm.generateQuestion(multipler: contentVm.multiplication)
            nextButtonClicked = false
        }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        MainBackgroundView {
            PlayView()
                .environmentObject(ContentViewModel())
        }
    }
}
