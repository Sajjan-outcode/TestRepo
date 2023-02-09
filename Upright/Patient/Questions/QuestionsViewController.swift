//
//  QuestionsViewController.swift
//  Upright
//
//  Created by USS - Software Dev on 3/11/22.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    var mainView:BaseViewController!
    var patientView: PatientProfileViewController!
    
    @IBAction func button1(_ sender: Any) {
        questionsEngine(answer: 1)
    }
    @IBAction func button2(_ sender: Any) {
        questionsEngine(answer: 2)
    }
    @IBAction func button3(_ sender: Any) {
        questionsEngine(answer: 3)
    }
    @IBAction func button4(_ sender: Any) {
        questionsEngine(answer: 4)
    }
    @IBAction func button5(_ sender: Any) {
        questionsEngine(answer: 5)
    }
    @IBAction func button6(_ sender: Any) {
        questionsEngine(answer: 6)
    }
    @IBAction func button7(_ sender: Any) {
        questionsEngine(answer: 7)
    }
    @IBAction func button8(_ sender: Any) {
        questionsEngine(answer: 8)
    }
    @IBAction func button9(_ sender: Any) {
        questionsEngine(answer: 9)
    }
    @IBAction func button10(_ sender: Any) {
        questionsEngine(answer: 10)
    }
    
    @IBAction func rightarrow(_ sender: Any) {
        if questionsPosition < 9 {
            questionsPosition += 1
            Question.text = questions[questionsPosition].question
            questionPosition.text = "\(questionsPosition + 1)|10"
        }
       
    }
 
    @IBAction func leftarrow(_ sender: Any) {
        if questionsPosition > 0 {
            questionsPosition -= 1
            Question.text = questions[questionsPosition].question
            questionPosition.text = "\(questionsPosition + 1)|10"
        }
        
    }
    
 
   
    @IBOutlet weak var left_arrow: UIButton!
    
    @IBOutlet weak var right_arrow: UIButton!
    
    
    
    @IBOutlet weak var Question: UILabel!
    
    @IBOutlet weak var questionPosition: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak var Score: UILabel!
    @IBOutlet weak var Results_View: RoundImageView!
    @IBAction func Survey_Submit(_ sender: Any){
        submit()
        
        present(mainView!, animated: false, completion: nil)
        //mainView?.setView(currentView: patientView!.view)
        mainView.displayContentController(content: patientView)
    }
    
    var questions:[Questions] = []
    var answers:[Int] = [10,9,8,7,6,5,4,3,2,1]
    var questionsPosition = 0
    var questionTotal = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "SxFx_Background.png"))
        //let screenHeight = UIScreen.main.fixedCoordinateSpace.bounds.height - self.navigationController?.navigationBar.frame.size.height - 20
        //self.tableView.rowHeight = screenHeight / 3
        createArray()
       
        
        
        Question.text = questions[0].question
        questionPosition.text = "\(questionsPosition  + 1)|10"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        left_arrow.isHidden = true
        right_arrow.isHidden = true
        
        patientView = storyboard?.instantiateViewController(withIdentifier: "PatientProfileViewController") as? PatientProfileViewController
        //navigationController?.pushViewController(patientView!, animated: true)
        mainView = storyboard?.instantiateViewController(withIdentifier: "BaseViewController") as? BaseViewController
        
    }
    
    func questionsEngine(answer: Int){
        questions[questionsPosition].answer = answer
        
        questionTotal += answer
        if(questionsPosition < 9){
            questionsPosition += 1
            Question.text = questions[questionsPosition].question
            questionPosition.text = "\(questionsPosition + 1)|10"
            self.left_arrow.isHidden = false
        } else {
            Results_View.isHidden = false
        }
        
//        if(questionsPosition >= 1){
//            left_arrow.isHidden = false
//            right_arrow.isHidden = false
//        }
//        else {
//            left_arrow.isHidden = true
//            right_arrow.isHidden = true
//        }
//        if(questionsPosition == 9){
//            right_arrow.isHidden = true
//        }
        Score.text = String(questionTotal)
        // print(questionsPosition)
    }
    
    func createArray() {
        var tempList: [Questions] = []
        
        let q1 = Questions(question: "How successful were you at sleeping through the night without pain?", answer: 0, time_stamp: "")
        let q2 = Questions(question: "How successful were you at getting out of bed without back or neck pain?", answer: 0, time_stamp: "")
        let q3 = Questions(question: "How successful were you at bathing and dressing without back or neck pain?", answer: 0, time_stamp: "")
        let q4 = Questions(question: "How successful were you at preparing, eating, and cleaning up meals without back or neck pain?", answer: 0, time_stamp: "")
        let q5 = Questions(question: "How successful were you at walking without back or neck pain?", answer: 0, time_stamp: "")
        let q6 = Questions(question: "How successful were you at traveling without back or neck pain?", answer: 0, time_stamp: "")
        let q7 = Questions(question: "How successful were you at performing morning work without back or neck pain?", answer: 0, time_stamp: "")
        let q8 = Questions(question: "How successful were you at performing afternoon work without back or neck pain?", answer: 0, time_stamp: "")
        let q9 = Questions(question: "How successful were you at relaxing without back or neck pain?", answer: 0, time_stamp: "")
        let q10 = Questions(question: "How successful were you at going to bed without back or neck pain?", answer: 0, time_stamp: "")
        
        tempList += [q1,q2,q3,q4,q5,q6,q7,q8,q9,q10]
        
        questions = tempList
        
    }
    
    func submit(){
        insertSurvey()
    }
    
    func insertSurvey(){
        let database: db = db()
        let value = "INSERT INTO survey (patient_id,score,time_stamp) VALUES (\(Patient.id!),\(questionTotal),current_timestamp);"
        let result = database.execute(text: value)
    
        print(result)
    }

}

extension QuestionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell") as! QuestionsViewCell
        
        cell.setAnswer(answer: answer)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedAnswer = answers[indexPath.row]
        questions[questionsPosition].answer = selectedAnswer
        
        questionTotal += selectedAnswer
        if(questionsPosition < 9){
            questionsPosition += 1
            Question.text = questions[questionsPosition].question
            questionPosition.text = "\(questionsPosition + 1)|10"
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            Results_View.isHidden = false
            
            
        }
       
        
        Score.text = String(questionTotal)
        print(questionTotal)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        cell.textLabel?.textAlignment = .center
    }
    
    
    
    
}
