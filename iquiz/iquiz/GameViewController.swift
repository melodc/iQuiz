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
    var currAnswer:Answer?
    var correct:String = ""
    
    var currScore:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //setupQuestions()
        if subject == "math" {
            gameModels = mathQuestions
        } else if subject == "marvel" {
            gameModels = marvelQuestions
        } else {
            gameModels = scienceQuestions
        }
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

    private func checkAnswer(answer: Answer, question: Question) -> Bool {
        return question.answers.contains(where: {$0.text == answer.text}) && answer.correct
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currQuestion?.answers.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answer", for: indexPath)
        cell.textLabel?.text = currQuestion?.answers[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let question = currQuestion else {
            return
        }
        
        let answer = question.answers[indexPath.row]
        currAnswer = answer
    }
    
    
    @IBAction func submitAnswer(_ sender: UIButton) {
        guard let question = currQuestion else {
            return
        }
        
        guard let answer = currAnswer else {
            return
        }
        
        if checkAnswer(answer: answer, question: question) {
            // correct screen
            currScore += 1
            correct = "You got it right!"
        } else {
            // incorrect
            correct = "Incorrect, better luck next time!"
        }

//        self.performSegue(withIdentifier: "revealAnswer", sender: self)
        
        let vc = storyboard?.instantiateViewController(identifier: "answer") as! AnswerViewController
        
        vc.question = question.text
        vc.correctAnswer = answer.text
        vc.correctStatement = correct
        vc.gameModels = gameModels
        vc.index = currQuestionNum
        vc.subject = subject
        vc.currScore = currScore
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func checkForMoreQuestions() {
        guard let question = currQuestion else {
            return
        }
    
        //check if there are anymore questions
        if let index = gameModels.firstIndex(where: { $0.text == question.text } ) {
            print(index)
            if index < (gameModels.count - 1) {
                let nextQuestion = gameModels[index+1]
                configureUI(question: nextQuestion)
                table.reloadData()
            } else {
                let vc = storyboard?.instantiateViewController(identifier: "finished") as! FinishedViewController
                vc.currScore = currScore
                vc.totalQuestions = gameModels.count - 1
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)

            }
        }
    }
    

}

var mathQuestions: [Question] = [
    Question(text: "What is 2 + 2?", answers: [Answer(text: "1", correct: false), Answer(text: "4", correct: true), Answer(text: "3", correct: false), Answer(text: "2", correct: false)]),
    Question(text: "What is 3 * 7?", answers: [Answer(text: "10", correct: false), Answer(text: "4", correct: false), Answer(text: "21", correct: true), Answer(text: "2", correct: false)]),
    Question(text: "What is 51 / 17?", answers: [Answer(text: "1", correct: false), Answer(text: "2.5", correct: false), Answer(text: "3", correct: true), Answer(text: "34", correct: false)])
    
]

var marvelQuestions: [Question] = [
    Question(text: "What is 2 + 2?", answers: [Answer(text: "1", correct: false), Answer(text: "4", correct: true), Answer(text: "3", correct: false), Answer(text: "2", correct: false)]),
    Question(text: "What is 3 * 7?", answers: [Answer(text: "10", correct: false), Answer(text: "4", correct: false), Answer(text: "21", correct: true), Answer(text: "2", correct: false)]),
    Question(text: "What is 51 / 17?", answers: [Answer(text: "1", correct: false), Answer(text: "2.5", correct: false), Answer(text: "3", correct: true), Answer(text: "34", correct: false)])
    
]

var scienceQuestions: [Question] = [
    Question(text: "What is 2 + 2?", answers: [Answer(text: "1", correct: false), Answer(text: "4", correct: true), Answer(text: "3", correct: false), Answer(text: "2", correct: false)]),
    Question(text: "What is 3 * 7?", answers: [Answer(text: "10", correct: false), Answer(text: "4", correct: false), Answer(text: "21", correct: true), Answer(text: "2", correct: false)]),
    Question(text: "What is 51 / 17?", answers: [Answer(text: "1", correct: false), Answer(text: "2.5", correct: false), Answer(text: "3", correct: true), Answer(text: "34", correct: false)])
    
]

struct Question {
    let text: String
    let answers: [Answer]
}

struct Answer {
    let text: String
    let correct: Bool //true or false
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
            //let nextQuestion = gameModels[index+1]
            let vc = storyboard?.instantiateViewController(identifier: "game") as! GameViewController
            vc.currQuestionNum = index+1
            vc.subject = subject
            vc.currScore = currScore
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
        
        scoreLabel.text = "Score: \(String(currScore)) correct out of \(String(totalQuestions)) questions"
    }
    
    
    @IBAction func returnHome(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "home")
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true)
    }
    
}
