//
//  APIClient.swift
//  SuperQuizz
//
//  Created by formation3 on 06/12/2018.
//  Copyright © 2018 formation3. All rights reserved.
//

import Foundation

class APIClient {
    
    static let instance = APIClient()
    var indexCorrectAnswer : Int = 0
    private let urlServer = "http://192.168.10.114:3000"
    
    private init (){
        
    }
    
    func getAllQuestion (onSucces:@escaping ([Question])->(), onError :@escaping (Error)->()) -> URLSessionTask{
        //préparation de la requete
        var request = URLRequest(url: URL(string: "\(urlServer)/questions")! )
        request.httpMethod = "GET"
        
        // preparation de la tache de telechargezmebnt des données
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // si j'ai de la donnée
            if let data = data {
                
                // Je la transforme en Array
                let dataArray = try! JSONSerialization.jsonObject(with: data, options: []) as! [Any]
                var questionsToreturn = [Question]()
                // pour chaque objet d'ans l'array
                for object in dataArray {
                    
                    let objectDictionary = object as! [String:Any]
                    let q  = Question(questionTitle: objectDictionary["title"] as! String)
                    q.idQuestion = (objectDictionary["id"] as! Int)
                    q.addProposition(proposition: objectDictionary["answer_1"] as! String)
                    q.addProposition(proposition: objectDictionary["answer_2"] as! String)
                    q.addProposition(proposition: objectDictionary["answer_3"] as! String)
                    q.addProposition(proposition: objectDictionary["answer_4"] as! String)
                    q.correctAnswer = q.propositions[(objectDictionary["correct_answer"] as! Int) - 1]
                    q.imgQuestion = (objectDictionary["author_img_url"] as? String)
                    q.author = (objectDictionary["author"] as? String)
                    //TODO : Finish question
                    questionsToreturn.append(q)
                }
                onSucces(questionsToreturn)
                
            } else  {
                onError(error!)
            }
        }
        // lance la tache
        task.resume()
        
        // revoie la tache pour pouvoir l'annuler
        return task
    }
    
    func deleteQuestion (q : Question, onSucces:@escaping (Question)->(), onError :@escaping (Error)->()) -> URLSessionTask{
        //préparation de la requete
        var request = URLRequest(url: URL(string: "\(urlServer)/questions/\(q.idQuestion!)")! )
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        putIndexCorrectAnswer(q: q)
        let json: [String : Any] = ["title" : q.questionTitle!,
                                    "answer_1" : q.propositions[0],
                                    "answer_2" : q.propositions[1],
                                    "answer_3" : q.propositions[2],
                                    "answer_4" : q.propositions[3],
                                    "correct_answer" : indexCorrectAnswer,
                                    "author" : q.author ?? "",
                                    "author_img" : q.imgQuestion ?? ""]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        // preparation de la tache de telechargezmebnt des données
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // si j'ai de la donnée
            if let data = data {
                onSucces(q)
            } else  {
                onError(error!)
            }
        }
        // lance la tache
        task.resume()
        
        // revoie la tache pour pouvoir l'annuler
        return task
    }
    
   
    func addQuestion (q : Question, onSucces:@escaping (Question)->(), onError :@escaping (Error)->()) -> URLSessionTask{
        //préparation de la requete
        var request = URLRequest(url: URL(string: "\(urlServer)/questions")! )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        putIndexCorrectAnswer(q: q)
        let json: [String : Any] = ["title" : q.questionTitle!,
                                    "answer_1" : q.propositions[0],
                                    "answer_2" : q.propositions[1],
                                    "answer_3" : q.propositions[2],
                                    "answer_4" : q.propositions[3],
                                    "correct_answer" : indexCorrectAnswer,
                                    "author" : q.author ?? "",
                                    "author_img" : q.imgQuestion ?? ""]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        // preparation de la tache de telechargezmebnt des données
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // si j'ai de la donnée
            if let data = data {
                onSucces(q)
            } else  {
                onError(error!)
            }
        }
        // lance la tache
        task.resume()
        
        // revoie la tache pour pouvoir l'annuler
        return task
    }
    //TODO : Put
    func updateQuestion (q : Question, onSucces:@escaping (Question)->(), onError :@escaping (Error)->()) -> URLSessionTask{
        //préparation de la requete
        var request = URLRequest(url: URL(string: "\(urlServer)/questions/\(q.idQuestion!)")! )
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        putIndexCorrectAnswer(q: q)
        let json: [String : Any] = ["title" : q.questionTitle!,
                                    "answer_1" : q.propositions[0],
                                    "answer_2" : q.propositions[1],
                                    "answer_3" : q.propositions[2],
                                    "answer_4" : q.propositions[3],
                                    "correct_answer" : indexCorrectAnswer,
                                    "author" : q.author ?? "",
                                    "author_img" : q.imgQuestion ?? ""]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        // preparation de la tache de telechargezmebnt des données
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // si j'ai de la donnée
            if let data = data {
                onSucces(q)
            } else  {
                onError(error!)
            }
        }
        // lance la tache
        task.resume()
        
        // revoie la tache pour pouvoir l'annuler
        return task
    }
    
    
    func putIndexCorrectAnswer (q: Question){
        for i in 0...3{
            if q.correctAnswer == q.propositions[i]{
                indexCorrectAnswer = i + 1
            }
        }
    }
}
