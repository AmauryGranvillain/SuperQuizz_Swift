//
//  Question.swift
//  SuperQuizz
//
//  Created by formation3 on 04/12/2018.
//  Copyright © 2018 formation3. All rights reserved.
//

import Foundation

class Question {
    
    var questionTitle : String?
    var propositions : [String] = [String]()
    var correctAnswer : String?
    var userChoice : String?
    
    init (questionTitle : String){
        self.questionTitle = questionTitle
    }
    
    func addProposition(proposition : String) {
        propositions.append(proposition)
    }
    
    func addCorrectAnswer(correctAnswer : String){
        self.correctAnswer = correctAnswer
    }
    
    func addUserChoice(userChoice : String){
        self.userChoice = userChoice
    }
}
