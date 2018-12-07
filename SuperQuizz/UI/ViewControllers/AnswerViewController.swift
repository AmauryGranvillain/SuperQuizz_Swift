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
    var timeOut : Bool = false
    var workItem : DispatchWorkItem?
    private var onQuestionAnswered : ((_ question : Question,_ isCorrectAnswer : Bool) -> ())?
    private var onTimeOut : ((_ question : Question,_ isTimeOut : Bool) -> ())?
    
    @IBOutlet weak var titleQuestionLabel: UILabel!
    
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    @IBOutlet weak var imgQuestion: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleQuestionLabel.text = question.questionTitle
        answerButton1.setTitle(question.propositions[0], for: .normal)
        answerButton2.setTitle(question.propositions[1], for: .normal)
        answerButton3.setTitle(question.propositions[2], for: .normal)
        answerButton4.setTitle(question.propositions[3], for: .normal)
        
        print(question.imgQuestion)
        guard let urlImg = question.imgQuestion else{return}
        print(urlImg)
        guard let url = URL(string: urlImg) else {return}
        print(url)
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {return}
            DispatchQueue.main.async {
                self.imgQuestion.image = UIImage(data: data)
            }
        }
        
        workItem = DispatchWorkItem {
            for i in 0...20 {
                Thread.sleep(forTimeInterval: 1)
                DispatchQueue.main.async {
                    self.progressBar.setProgress(Float(i)*0.05, animated: true)
                }
            }
            DispatchQueue.main.async {
                self.question.userChoice = "false"
                self.onQuestionAnswered?(self.question,false)
            }
        }
        DispatchQueue.global(qos: .userInitiated).async(execute: workItem!)
    }
    
    
    @IBAction func selectAnswer(_ sender: UIButton) {
        if question.correctAnswer == sender.titleLabel?.text{
            resultAnswer = true
        } else {
            resultAnswer = false
        }
        question.userChoice = sender.titleLabel?.text
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

