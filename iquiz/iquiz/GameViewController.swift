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
        if subject == "Mathematics" {
            gameModels = mathQuestions
        } else if subject == "Marvel Super Heroes" {
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
        cell.textLabel?.numberOfLines = 0;
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)

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
    Question(text: "What is 51 / 17?", answers: [Answer(text: "1", correct: false), Answer(text: "2.5", correct: false), Answer(text: "3", correct: true), Answer(text: "34", correct: false)]),
    Question(text: "0.006 = __ %?", answers: [Answer(text: "0.6", correct: true), Answer(text: "0.06", correct: false), Answer(text: "0.006", correct: false), Answer(text: "0.0006", correct: false)]),
    Question(text: "(-4) x (-3) = ?", answers: [Answer(text: "-12", correct: false), Answer(text: "12", correct: true), Answer(text: "1", correct: false), Answer(text: "1.2", correct: false)]),
    Question(text: "What is the next prime number after 5?", answers: [Answer(text: "6", correct: false), Answer(text: "7", correct: true), Answer(text: "9", correct: false), Answer(text: "11", correct: false)]),
    Question(text: "5 raised to the power 0 is equal to?", answers: [Answer(text: "4", correct: false), Answer(text: "3", correct: false), Answer(text: "2", correct: false), Answer(text: "1", correct: true)]),
    Question(text: "Cube root of 1331 is?", answers: [Answer(text: "9", correct: false), Answer(text: "10", correct: false), Answer(text: "11", correct: true), Answer(text: "12", correct: false)]),
    Question(text: "Complete The Fibonacci Sequences 0,1,1,2,3,5,8,13,21,34,_", answers: [Answer(text: "36", correct: false), Answer(text: "45", correct: false), Answer(text: "49", correct: false), Answer(text: "55", correct: true)]),
    Question(text: "Find the coefficient of x2 in the Taylor series about x = 0 for f(x) = e−x2 .", answers: [Answer(text: "1/4", correct: false), Answer(text: "-1", correct: true), Answer(text: "1/2", correct: false), Answer(text: "-2", correct: false)]),
    
]

var marvelQuestions: [Question] = [
    Question(text: "What is the name of Thor’s hammer?", answers: [Answer(text: "Vanir", correct: false), Answer(text: "Mjolnir", correct: true), Answer(text: "Aesir", correct: false), Answer(text: "Norn", correct: false)]),
    Question(text: "What is Captain America’s shield made of?", answers: [Answer(text: "Adamantium", correct: false), Answer(text: "Vibranium", correct: true), Answer(text: "Promethium", correct: false), Answer(text: "Carbonadium", correct: false)]),
    Question(text: "What is the real name of the Black Panther?", answers: [Answer(text: "T’Challa", correct: true), Answer(text: "M’Baku", correct: false), Answer(text: "N’Jadaka", correct: false), Answer(text: "N’Jobu", correct: false)]),
    Question(text: "Who was the last holder of the Space Stone before Thanos claims it for his Infinity Gauntlet?", answers: [Answer(text: "Thor", correct: false), Answer(text: "Loki", correct: true), Answer(text: "The Collector", correct: true), Answer(text: "Tony Stark", correct: false)]),
    Question(text: "Who does the Mad Titan sacrifice to acquire the Soul Stone?", answers: [Answer(text: "Nebula", correct: false), Answer(text: "Ebony Maw", correct: false), Answer(text: "Cull Obsidian", correct: false), Answer(text: "Gamora", correct: true)]),
    Question(text: "What is the name of the little boy Tony befriends while stranded in the Iron Man 3?", answers: [Answer(text: "Harry", correct: false), Answer(text: "Henry", correct: false), Answer(text: "Harley", correct: true), Answer(text: "Holden", correct: false)]),
    Question(text: "Who is killed by Loki in the Avengers?", answers: [Answer(text: "Maria Hill", correct: false), Answer(text: "Nick Fury", correct: false), Answer(text: "Agent Coulson", correct: true), Answer(text: "Doctor Erik Selvig", correct: false)]),
    Question(text: "Who is Black Panther’s sister?", answers: [Answer(text: "Shuri", correct: true), Answer(text: "Nakia", correct: false), Answer(text: "Okoye", correct: true), Answer(text: "Ramonda", correct: false)]),
    Question(text: "What year was the first Iron Man movie released?", answers: [Answer(text: "2005", correct: false), Answer(text: "2006", correct: false), Answer(text: "2007", correct: true), Answer(text: "2008", correct: true)]),
    Question(text: "What does the Winter Soldier say after Steve recognizes him for the first time?", answers: [Answer(text: "“Who the hell is Bucky?”", correct: true), Answer(text: "“Do I know you?”", correct: false), Answer(text: "“He’s gone.”", correct: false), Answer(text: "“What did you say?”", correct: false)]),
]

var scienceQuestions: [Question] = [
    Question(text: "What is the nearest planet to the sun?", answers: [Answer(text: "Mercury", correct: true), Answer(text: "Venus", correct: true), Answer(text: "Earth", correct: false), Answer(text: "Mars", correct: false)]),
    Question(text: "How many teeth does an adult human have?", answers: [Answer(text: "24", correct: false), Answer(text: "32", correct: true), Answer(text: "36", correct: false), Answer(text: "40", correct: false)]),
    Question(text: "What is the hardest known natural material?", answers: [Answer(text: "Steel", correct: false), Answer(text: "Ruby", correct: false), Answer(text: "Diamond", correct: true), Answer(text: "Gold", correct: false)]),
    Question(text: "What is the hottest planet in the solar system?", answers: [Answer(text: "Mercury", correct: false), Answer(text: "Venus", correct: true), Answer(text: "Earth", correct: false), Answer(text: "Mars", correct: false)]),
    Question(text: "What is the rarest blood type?", answers: [Answer(text: "A positive", correct: false), Answer(text: "B negative", correct: false), Answer(text: "AB positive", correct: false), Answer(text: "AB negative", correct: true)]),
    Question(text: "What’s the boiling point of water?", answers: [Answer(text: "100 degrees Celcius", correct: true), Answer(text: "101 degrees Celcius", correct: false), Answer(text: "212 degrees Celcius", correct: true), Answer(text: "500 degrees Celcius", correct: false)]),
    Question(text: "How many elements are there in the periodic table?", answers: [Answer(text: "1", correct: false), Answer(text: "239", correct: false), Answer(text: "118", correct: true), Answer(text: "1000", correct: false)]),
    Question(text: "The oldest living tree is 4,843 years old and can be found where?", answers: [Answer(text: "California", correct: true), Answer(text: "Washington", correct: false), Answer(text: "Arizona", correct: false), Answer(text: "New Mexico", correct: false)]),
    Question(text: "Which of Newton’s Laws state that ‘for every action, there is an equal and opposite reaction?", answers: [Answer(text: "The first law of motion", correct: false), Answer(text: "The second law of motion", correct: false), Answer(text: "The third law of motion", correct: true), Answer(text: "The law of gravity", correct: false)]),
    Question(text: "The lac operon is only found in prokaryotes and has structural genes, a promoter, and an operator. Why do we study the lac operon?", answers: [Answer(text: "It is the main way gene transcription is regulated.", correct: true), Answer(text: "It shows the difference between prokaryotes and eukaryotes.", correct: false), Answer(text: "It helps us know how to control the cell cycle if uncontrollable cell growth takes place.", correct: false), Answer(text: "It shows how RNA is processed after it is transcribed.", correct: false)]),
    
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
        
        if currScore == 0 {
            desc.text = "There's no way you got everything wrong..."
        } else if currScore < 4 {
            desc.text = "There's lots of room for improvement!"
        } else if currScore < 8 {
            desc.text = "Better luck next time!"
        } else if currScore == 9 {
            desc.text = "Almost!"
        } else {
            desc.text = "Perfect!"
        }
        
        scoreLabel.text = "Score: \(String(currScore)) correct out of \(String(totalQuestions)) questions"
    }
    
    
    @IBAction func returnHome(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "home")
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true)
    }
    
}
