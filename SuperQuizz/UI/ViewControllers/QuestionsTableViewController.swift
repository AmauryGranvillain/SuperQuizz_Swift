//
//  QuestionsTableViewController.swift
//  SuperQuizz
//
//  Created by formation3 on 04/12/2018.
//  Copyright © 2018 formation3. All rights reserved.
//

import UIKit

class QuestionsTableViewController: UITableViewController {
    
    var allQuestion : [Question] = [Question]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
        
        let q1 = Question(questionTitle: "Quelle est le jeu esport le plus joué ?")
        q1.addProposition(proposition: "Overwatch")
        q1.addProposition(proposition: "League of Legends")
        q1.addProposition(proposition: "Clash Royal")
        q1.addProposition(proposition: "Counter Strike")
        q1.addCorrectAnswer(correctAnswer: "Clash Royal")
        
        let q2 = Question(questionTitle: "Quelle est la capitale de la Finlande ?")
        q2.addProposition(proposition: "Helsinski")
        q2.addProposition(proposition: "Copenhague")
        q2.addProposition(proposition: "Stockholm")
        q2.addProposition(proposition: "Oslo")
        q2.addCorrectAnswer(correctAnswer: "Helsinski")
        
        addQuestion(q : q1)
        addQuestion(q : q2)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allQuestion.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
        
        cell.questionTitleLabel.text = allQuestion[indexPath.row].questionTitle
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AnswerViewController") as? AnswerViewController else{
            return
        }
        
        vc.question = allQuestion[indexPath.row]
        vc.setOnReponseAnswered { (questionAnswered, result) in
            //TODO : Mettre à jour la liste, ou faire un appel reseau, ou mettre à jour la base
            self.navigationController?.popViewController(animated: true)
            self.tableView.reloadData()
        }
        self.show(vc, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexpath) in
            //TODO: edit question
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateOrEditQuestionViewController") as! CreateOrEditQuestionViewController
            controller.delegate = self
            controller.questionToEdit = self.allQuestion[indexPath.row]
            self.present(controller, animated: true, completion: nil)
            
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexpath) in
            self.allQuestion.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        return [editAction,deleteAction]
    }
    
    func addQuestion (q : Question){
        allQuestion.append(q)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCreateOrEditViewController" {
            let controller = segue.destination as! CreateOrEditQuestionViewController
            controller.delegate = self
        }
    }
}

extension QuestionsTableViewController : CreateOrEditQuestionDelegate {
    func userDidEditQuestion(q: Question) {
        self.tableView.reloadData()
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func userDidCreateQuestion(q: Question) {
        addQuestion(q: q)
        self.tableView.reloadData()
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
