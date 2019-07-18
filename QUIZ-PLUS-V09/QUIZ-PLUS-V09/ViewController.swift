//
//  ViewController.swift
//  QUIZ-PLUS-V09
//
//  Created by Raymond Choy on 7/18/19.
//  Copyright © 2019 thechoygroup. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    // MARK: - Constants
    
    let CORNERRADIUS: CGFloat = 10.0
    
    var questionsAsked = 0
    var correctQuestions = 0
    var questionsPerRound = 4
    var gameManager = GameManager()
    var myQuiz = Quiz()
    var mySoundManager = SoundManager()
    weak var myTimer: Timer!
    var timerTime = 15

    @IBOutlet weak var questionField: UILabel!
    
    @IBOutlet weak var answerButtonA: UIButton!
    @IBOutlet weak var answerButtonB: UIButton!
    @IBOutlet weak var answerButtonC: UIButton!
    @IBOutlet weak var answerButtonD: UIButton!
    @IBOutlet var answerButtons: [UIButton]!

    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var timerField: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        answerButtonA.layer.cornerRadius = CORNERRADIUS
        answerButtonB.layer.cornerRadius = CORNERRADIUS
        answerButtonC.layer.cornerRadius = CORNERRADIUS
        answerButtonD.layer.cornerRadius = CORNERRADIUS
        playAgainButton.layer.cornerRadius = CORNERRADIUS
        
        answerButtons = [self.answerButtonA, self.answerButtonB, self.answerButtonC, self.answerButtonD]
        playAgainButton.setTitle("Play Again", for: .normal)
        displayQuestion()
        self.questionsPerRound = gameManager.questionsAsked
    }
    
    // GENERAL FONCTIONS BASED ON GAME MANAGER
    func displayQuestion() {
        
        // reset display
        questionField.textColor = UIColor.white
        self.hideAllButtons()
        timerField.text = "" // if not, it shows "Label" for a 0.5 second
        for answerButton in answerButtons {
            answerButton.tintColor = UIColor.white
            answerButton.isHighlighted = false // tried the highlight but it did not look nice
        }
        
        // display questions and timer
        timerField.isHidden = false
        self.startTimer()
        let currentQuestion: Question = gameManager.myQuestions[gameManager.currentRound]
        questionField.text = currentQuestion.question
        
        // display only possible answers
        for i in 0..<currentQuestion.options.count {
            answerButtons[i].isHidden = false
            
            answerButtons[i].setTitle(currentQuestion.options[i], for: .normal)
        }
    }
    
    func displayScore() {
        // setup the screen
        self.hideAllButtons()
        playAgainButton.isHidden = false
        
        // display results
        if self.correctQuestions == 0 {
            questionField.text = "You did not even get one answer right..."
        } else if self.correctQuestions == 1 {
            questionField.text = "You got only \(self.correctQuestions) correct answer out of \(gameManager.questionsAsked)"
        } else {
            questionField.text = "You got \(self.correctQuestions) correct answers out of \(gameManager.questionsAsked)"
        }
    }
    
    func nextRound() {
        if gameManager.currentRound == questionsPerRound {
            timerField.isHidden = true
            displayScore()
        } else {
            displayQuestion()
        }
    }
    
    // buttons and display functions
    func loadNextRound(delay seconds: Int) {
        self.endTimer()
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    func hideAllButtons() {
        for answerButton in self.answerButtons{
            answerButton.isHidden = true
            playAgainButton.isHidden = true
        }
    }
    
    func questionCorrection (question: Question, answer: String) {
        let correctAnswer: String = gameManager.correctAnswer(currentQuestion: question)
        
        // highlight answer buttons
        for (answerButton) in answerButtons {
            switch answerButton.title(for: . normal)
            {
            case correctAnswer:
                answerButton.tintColor = UIColor.green
            case answer:
                answerButton.tintColor = UIColor.red
            default: answerButton.tintColor = UIColor.gray
            }
        }
        
        // adjust messaging, score and sound
        if answer == "" {
            mySoundManager.playBadAnswerSound()
            gameManager.nextRound()
            questionField.text = "Too slow! \nThe answer was \(correctAnswer)"
            self.loadNextRound(delay: 2)
        } else if gameManager.checkAnswer(selectedAnswer: answer , currentQuestion: question) == true {
            mySoundManager.playGoodAnswerSound()
            questionField.text = "Correct!"
            self.loadNextRound(delay: 1)
            self.correctQuestions += 1
        } else {
            mySoundManager.playBadAnswerSound()
            questionField.text = "Wrong answer! \nThe answer was \(correctAnswer)"
            self.loadNextRound(delay: 2)
        }
    }
    
    // ACTIONS

    @IBAction func checkAnswer(_ sender: UIButton) {
        // question parameter
        let currentRound = gameManager.currentRound
        let currentQuestion: Question = gameManager.myQuestions[currentRound]
        let selectedAnswer: String = sender.title(for: .normal)!
        
        //hide timer
        timerField.isHidden = true
        
        //fonction displaying correction screen
        self.questionCorrection(question: currentQuestion, answer: selectedAnswer)
    }
    
    
    @IBAction func playAgainButton(_ sender: UIButton) {

        //reset View Controler data
        self.questionsAsked = 0
        self.correctQuestions = 0
        //reset GameManager data
        gameManager.gameReset()
        //launch new game
        displayQuestion()
    }
    
    
    // TIMER
    func startTimer() {
        // make sure a timer is not already  running
        endTimer()
        // setup new timer
        timerField.textColor = UIColor.white
        self.timerTime = 15
        self.myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timerField.text = "\(timeFormatted(timerTime))"
        
        if self.timerTime != 0 {
            self.timerTime -= 1
            if self.timerTime < 5 {
                timerField.textColor = UIColor.red
            } else {}
            
        } else {
            // display results
            timerField.isHidden = false
            timerField.textColor = UIColor.red
            timerField.text = "00"
            let currentQuestion: Question = gameManager.myQuestions[gameManager.currentRound]
            self.questionCorrection(question: currentQuestion, answer: "")
            // next round
            self.loadNextRound(delay: 2)
        }
    }
    
    func endTimer() {
        myTimer?.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        return String(format: "%02d", seconds)
    }
}
