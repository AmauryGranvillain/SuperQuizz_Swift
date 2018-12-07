//
//  QuestionsTableViewController.swift
//  SuperQuizz
//
//  Created by formation3 on 04/12/2018.
//  Copyright © 2018 formation3. All rights reserved.
//

import UIKit
import SwiftIcons

class QuestionsTableViewController: UITableViewController {
    
    var allQuestion : [Question] = [Question]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
        
        APIClient.instance.getAllQuestion(onSucces: { (questions) in
            self.allQuestion = questions
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error)
        }
        
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
        
        cell.questionTitleLabel.text = allQuestion[indexPath.row].questionTitle
        if allQuestion[indexPath.row].userChoice == nil{
                cell.iconQuestion.setIcon(icon: .fontAwesomeSolid(.chevronRight), textColor: UIColor(red:0.91, green:0.77, blue:0.42, alpha:1.0), backgroundColor: UIColor.white, size: CGSize(width: 30, height: 30))
        } else {
            if allQuestion[indexPath.row].userChoice == allQuestion[indexPath.row].correctAnswer{
                cell.questionTitleLabel.textColor = UIColor(red:0.16, green:0.62, blue:0.56, alpha:1.0)
                cell.iconQuestion.setIcon(icon: .fontAwesomeRegular(.checkCircle), textColor: UIColor(red:0.16, green:0.62, blue:0.56, alpha:1.0), backgroundColor: UIColor.white, size: CGSize(width: 30, height: 30))
            } else {
                cell.questionTitleLabel.textColor = UIColor(red:0.91, green:0.44, blue:0.32, alpha:1.0)
                cell.iconQuestion.setIcon(icon: .fontAwesomeRegular(.timesCircle), textColor:UIColor(red:0.91, green:0.44, blue:0.32, alpha:1.0), backgroundColor: UIColor.white, size: CGSize(width: 30, height: 30))
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AnswerViewController") as? AnswerViewController else{
            return
        }
        
        vc.question = allQuestion[indexPath.row]
        vc.setOnReponseAnswered { (questionAnswered, result) in
            vc.workItem?.cancel()
            self.navigationController?.popViewController(animated: true)
            self.tableView.reloadData()
        }
        self.show(vc, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexpath) in
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateOrEditQuestionViewController") as! CreateOrEditQuestionViewController
            controller.delegate = self
            controller.questionToEdit = self.allQuestion[indexPath.row]
            self.present(controller, animated: true, completion: nil)
            
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexpath) in
            APIClient.instance.deleteQuestion(q: self.allQuestion[indexPath.row], onSucces: { (question) in
                DispatchQueue.main.async {
                    self.allQuestion.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            }, onError: { (Error) in
                print(Error)
            })
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
        APIClient.instance.updateQuestion(q: q, onSucces: { (question) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (Error) in
            print(Error)
        }
        self.tableView.reloadData()
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func userDidCreateQuestion(q: Question) {
        APIClient.instance.addQuestion(q: q, onSucces: { (question) in
            DispatchQueue.main.async {
                self.addQuestion(q: q)
                self.tableView.reloadData()
            }
        }) { (Error) in
            print(Error)
        }
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
