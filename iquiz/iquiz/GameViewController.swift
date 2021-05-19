//
//  GameViewController.swift
//  iquiz
//
//  Created by Melody Chou on 5/13/21.
//

import UIKit

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var gameModels = [Question]()
    var subject:String = ""
    var currQuestionNum:Int = 0
    
    @IBOutlet var label: UILabel!
    @IBOutlet var table: UITableView!
    
    @IBOutlet var scoreLabel: UILabel!
    
    var currQuestion:Question?
    var currAnswer:Int?
    var correct:String = ""
    
    var currScore:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUI(question: gameModels[currQuestionNum])
    }
    
    private func configureUI(question: Question) {
        label.text = question.text
        currQuestion = question
        table.delegate = self
        table.dataSource = self
    }

    private func checkAnswer(answer: Int, answered: Int) -> Bool {
        return answered == answer - 1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currQuestion?.answers.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answer", for: indexPath)
        cell.textLabel?.text = currQuestion?.answers[indexPath.row]
        cell.textLabel?.numberOfLines = 0;
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)

        currAnswer = indexPath.row
    }
    
    
    @IBAction func submitAnswer(_ sender: UIButton) {
        guard let question = currQuestion else {
            return
        }
        
        guard let answered = currAnswer else {
            return
        }
        
        if checkAnswer(answer: Int(question.answer)!, answered: answered) {
            // correct screen
            currScore += 1
            correct = "You got it right!"
        } else {
            // incorrect
            correct = "Incorrect, better luck next time!"
        }
        
        let vc = storyboard?.instantiateViewController(identifier: "answer") as! AnswerViewController
        
        vc.question = question.text
        vc.correctAnswer = question.answers[Int(question.answer)! - 1]
        vc.correctStatement = correct
        vc.gameModels = gameModels
        vc.index = currQuestionNum
        vc.subject = subject
        vc.currScore = currScore
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
//    func checkForMoreQuestions() {
//        guard let question = currQuestion else {
//            return
//        }
//    
//        //check if there are anymore questions
//        if let index = gameModels.firstIndex(where: { $0.text == question.text } ) {
//            print(index)
//            if index < (gameModels.count - 1) {
//                let nextQuestion = gameModels[index+1]
//                configureUI(question: nextQuestion)
//                table.reloadData()
//            } else {
//                let vc = storyboard?.instantiateViewController(identifier: "finished") as! FinishedViewController
//                vc.currScore = currScore
//                vc.totalQuestions = gameModels.count - 1
//                vc.modalPresentationStyle = .fullScreen
//                present(vc, animated: true)
//
//            }
//        }
//    }
    
}


class AnswerViewController: UIViewController {

    var question:String = ""
    var correctAnswer:String = ""
    var correctStatement:String = ""
    var gameModels:[Question] = []
    var index:Int = 0
    var currScore:Int = 0
    var subject:String = ""
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var correctAnswerLabel: UILabel!
    @IBOutlet var correctLabel: UILabel!
    @IBOutlet var nextQuestion: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        questionLabel.text = question
        correctAnswerLabel.text = correctAnswer
        correctLabel.text = correctStatement
    }
    
    @IBAction func getNextQuestion(_ sender: UIButton) {
        if index < (gameModels.count - 1) {
            print(index)
            let vc = storyboard?.instantiateViewController(identifier: "game") as! GameViewController
            vc.currQuestionNum = index+1
            vc.subject = subject
            vc.currScore = currScore
            vc.gameModels = gameModels
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        } else {
            print("finished!")
            let vc = storyboard?.instantiateViewController(identifier: "finished") as! FinishedViewController
            vc.currScore = currScore
            vc.totalQuestions = gameModels.count
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)

        }
    
    }
    
}

class FinishedViewController: UIViewController {
    
    var currScore:Int = 0
    var totalQuestions:Int = 0
    
    @IBOutlet var desc: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var returnHome: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let percentage = Double(currScore) / Double(totalQuestions) * 100.0
        if percentage == 0 {
            desc.text = "No way, you got everything wrong..."
        } else if percentage < 40 {
            desc.text = "There's lots of room for improvement!"
        } else if percentage < 80 {
            desc.text = "Better luck next time!"
        } else if percentage == 90 {
            desc.text = "Almost!"
        } else {
            desc.text = "Perfect!"
        }
        
        scoreLabel.text = "Score: \(String(currScore)) correct out of \(String(totalQuestions)) questions"
    }
    
    
    @IBAction func returnHome(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "home") as! ViewController
        var decodedData: [Subject] = []
        if let data = UserDefaults.standard.value(forKey:"bank") as? Data {
            decodedData = try! PropertyListDecoder().decode([Subject].self, from: data)
        }
        vc.allData = decodedData
        vc.subjects = decodedData.map { $0.title }
        vc.descriptions = decodedData.map { $0.desc }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}
