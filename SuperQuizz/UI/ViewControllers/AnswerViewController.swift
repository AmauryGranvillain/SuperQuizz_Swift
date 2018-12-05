//
//  ViewController.swift
//  SuperQuizz
//
//  Created by formation3 on 04/12/2018.
//  Copyright © 2018 formation3. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
    
    var question : Question!
    var resultAnswer : Bool = false
    private var onQuestionAnswered : ((_ question : Question,_ isCorrectAnswer : Bool) -> ())?

    @IBOutlet weak var titleQuestionLabel: UILabel!
    
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleQuestionLabel.text = question.questionTitle
        answerButton1.setTitle(question.propositions[0], for: .normal)
        answerButton2.setTitle(question.propositions[1], for: .normal)
        answerButton3.setTitle(question.propositions[2], for: .normal)
        answerButton4.setTitle(question.propositions[3], for: .normal)
    }
    
    
    @IBAction func selectAnswer(_ sender: UIButton) {
        if question.correctAnswer == sender.titleLabel?.text{
            resultAnswer = true
        } else {
            resultAnswer = false
        }
        userDidChooseAnswer(isCorrectAnswer: resultAnswer)
        
    }
    
    func setOnReponseAnswered(closure : @escaping (_ question: Question,_ isCorrectAnswer :Bool)->()) {
        onQuestionAnswered = closure
    }
    
    func userDidChooseAnswer (isCorrectAnswer : Bool){
        if isCorrectAnswer == true {
            let alert = UIAlertController(title: "Result", message: "Good answer !", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes !", style: .default, handler: { (action) in
                self.onQuestionAnswered?(self.question,isCorrectAnswer)
            }))
            
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Result", message: "Wrong answer ...", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Shame ...", style: .default, handler: { (action) in
                self.onQuestionAnswered?(self.question,isCorrectAnswer)
            }))
            
            self.present(alert, animated: true)
        }
    }
}

