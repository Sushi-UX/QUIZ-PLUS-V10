//
//  GameManager.swift
//  QUIZ-PLUS-V09
//
//  Created by Raymond Choy on 7/18/19.
//  Copyright © 2019 thechoygroup. All rights reserved.
//

import Foundation
import GameKit

struct GameManager {
    var score: Int = 0
    var questionsAsked = 4
    var currentRound = 0
    var myQuiz = Quiz()
    var myQuestions: [Question] = []
    
    init() {
        chooseQuestions()
    }
    
    mutating func chooseQuestions() {
        let shuffled = myQuiz.allQuestions
        self.myQuestions = Array(shuffled).shuffled()
    }
    
    func correctAnswer(currentQuestion: Question)->String {
        let options = currentQuestion.options
        let correctAnswer = options![currentQuestion.answer]
        return correctAnswer
    }
    
    mutating func checkAnswer(selectedAnswer: String, currentQuestion: Question) -> Bool {
        self.nextRound()
        if selectedAnswer == correctAnswer(currentQuestion: currentQuestion) {
            self.score += 1
            return true
        } else {
            return false
        }
    }
    
    mutating func nextRound() { // not in checkAnswer so can be called without checking answer (timer)
        self.currentRound += 1
    }
    
    mutating func gameReset () {
        self.score = 0
        self.currentRound = 0
        self.chooseQuestions()
    }
}

