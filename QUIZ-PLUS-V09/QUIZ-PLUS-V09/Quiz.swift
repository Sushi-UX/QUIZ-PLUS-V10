//
//  Quiz.swift
//  QUIZ-PLUS-V09
//
//  Created by Raymond Choy on 7/18/19.
//  Copyright © 2019 thechoygroup. All rights reserved.
//

import Foundation

struct Quiz {
    let questions = [
        "This was the only US President to serve more than two consecutive terms.",
        "Which of the following countries has the most residents?",
        "In what year was the United Nations founded?",
        "The Titanic departed from the United Kingdom, where was it supposed to arrive?",
        "Which nation produces the most oil?",
        "Which country has most recently won consecutive World Cups in Soccer?",
        "Which of the following rivers is longest?",
        "Which city is the oldest?",
        "Which country was the first to allow women to vote in national elections?",
        "Which of these countries won the most medals in the 2012 Summer Games?"
    ]
    
    let options = [
        ["George Washington", "Franklin D. Roosevelt", "Woodrow Wilson"],
        ["Nigeria", "Russia", "Iran", "Vietnam"],
        ["1918", "1919", "1945", "1954"],
        ["Paris", "Washington D.C.", "New York City"],
        ["Iran", "Iraq", "Brazil", "Canada"],
        ["Italy", "Brazil", "Argetina"],
        ["Yangtze", "Mississippi", "Congo", "Mekong"],
        ["Mexico City", "Cape Town", "San Juan", "Sydney"],
        ["Poland", "United States", "Sweden"],
        ["France", "Germany", "Japan", "Great Britian"]
    ]
    
    let answers = [1,0,2,2,3,1,1,0,0,3]
    
    var allQuestions: [Question] = []
    
    init(){
        for i in 0...questions.count-1 {
            let currentQuestion: Question = Question(question: questions[i], options: options[i], answer: answers[i])
            allQuestions.append(currentQuestion)
        }
    }
}

