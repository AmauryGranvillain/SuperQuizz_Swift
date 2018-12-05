//
//  CreateOrEditQuestionViewController.swift
//  SuperQuizz
//
//  Created by formation3 on 05/12/2018.
//  Copyright © 2018 formation3. All rights reserved.
//

import UIKit

protocol CreateOrEditQuestionDelegate : AnyObject {
    func userDidEditQuestion(q : Question) -> ()
    func userDidCreateQuestion(q : Question) -> ()
}

class CreateOrEditQuestionViewController: UIViewController {
    
    var questionToEdit: Question?
    var correctAnswer : String?
    weak var delegate : CreateOrEditQuestionDelegate?
    
    @IBOutlet weak var titleQuestionText: UITextField!
    @IBOutlet weak var textAnswer1: UITextField!
    @IBOutlet weak var textAnswer2: UITextField!
    @IBOutlet weak var textAnswer3: UITextField!
    @IBOutlet weak var textAnswer4: UITextField!
    
    @IBOutlet weak var checkAnswer1: UISwitch!
    @IBOutlet weak var checkAnswer2: UISwitch!
    @IBOutlet weak var checkAnswer3: UISwitch!
    @IBOutlet weak var checkAnswer4: UISwitch!
    
    @IBOutlet weak var validQuestionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func createOrEditQuestion () {
        updateCorrectAnswer()
        if let question = questionToEdit {
            question.questionTitle = titleQuestionText.text
            question.propositions[0] = textAnswer1.text ?? ""
            question.propositions[1] = textAnswer1.text ?? ""
            question.propositions[2] = textAnswer1.text ?? ""
            question.propositions[3] = textAnswer1.text ?? ""
            question.correctAnswer = correctAnswer
            delegate?.userDidEditQuestion(q: question)
        } else {
            let question = Question(questionTitle: titleQuestionText.text ?? "")
            question.addProposition(proposition: textAnswer1.text ?? "")
            question.addProposition(proposition: textAnswer2.text ?? "")
            question.addProposition(proposition: textAnswer3.text ?? "")
            question.addProposition(proposition: textAnswer4.text ?? "")
            question.addCorrectAnswer(correctAnswer: correctAnswer ?? "")
            delegate?.userDidCreateQuestion(q: question)
        }
    }
    
    @IBAction func selectCorrectAnswer(_ sender: UISwitch) {
        checkAnswer1.setOn(false, animated: true)
        checkAnswer2.setOn(false, animated: true)
        checkAnswer3.setOn(false, animated: true)
        checkAnswer4.setOn(false, animated: true)
        
        sender.setOn(true, animated: true)
    }
    
    func updateCorrectAnswer (){
        if checkAnswer1.isOn{
            correctAnswer = textAnswer1.text
        } else if checkAnswer2.isOn{
            correctAnswer = textAnswer2.text
        } else if checkAnswer3.isOn{
            correctAnswer = textAnswer3.text
        } else if checkAnswer4.isOn{
            correctAnswer = textAnswer4.text
        } else {
            let alert = UIAlertController(title: "ERROR", message: "Don't check the correct answer", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok...", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.show(alert, sender: self)
        }
    }
    
    @IBAction func validCreateOrEditQuestionButton(_ sender: UIButton) {
        createOrEditQuestion()
    }
}
