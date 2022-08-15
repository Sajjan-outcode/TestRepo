//
//  PatientProfileViewController.swift
//  Upright
//
//  Created by USS - Software Dev on 3/10/22.
//

import UIKit
import SwiftUI


class PatientProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var surveyTableView: UITableView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var Phone_Number: UILabel!
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var City_State_Zip: UILabel!
    @IBOutlet weak var survey_score: UILabel!
    @IBOutlet weak var segittal_index: UILabel!
    @IBOutlet weak var clinical_score: UILabel!
    @IBOutlet weak var program_progress: UILabel!
    @IBOutlet weak var uprightly_score: UILabel!
    @IBOutlet weak var delta_score: UILabel!
    @IBOutlet weak var lean: UILabel!
    @IBOutlet weak var cervical: UILabel!
    @IBOutlet weak var thoracic: UILabel!
    @IBOutlet weak var lumbar: UILabel!
    @IBOutlet weak var spin_pic: UIImageView!
    
    
    @IBAction func ReferPatient(_ sender: Any) {
       
    }
    
    @IBAction func New_Scan(_ sender: Any) {
        present(mainView!, animated: false, completion: nil)
        mainView?.setView(currentView: scanView!.view)
    }
    @IBAction func New_Survey(_ sender: Any) {
        present(mainView!, animated: false, completion: nil)
        mainView?.setView(currentView: questionView!.view)
    }
    
    var patient_id:Int?
    var scanslist: [PatientScan] = []
    var surveylist: [QuestionsScore] = []
    
    var mainView: MainViewController?
    var scanView: ScanControllsViewController?
    var questionView: QuestionsViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        surveyTableView.delegate = self
        surveyTableView.dataSource = self
        
        name.text = Patient.first_name! + " " + Patient.last_name!
        dob.text = Patient.date_of_birth as! String
        email.text = Patient.email
        Address.text = Patient.address
        City_State_Zip.text = Patient.city! + "," + Patient.state! + " " + Patient.zip!
        Phone_Number.text = Patient.phone_number
        self.patient_id = Patient.id!
        
//        ReferPatientButton.configuration?.titleAlignment = .center
        
        mainView = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        scanView = storyboard?.instantiateViewController(withIdentifier: "ScanControllsViewController") as? ScanControllsViewController
        questionView = storyboard?.instantiateViewController(withIdentifier: "QuestionsViewController") as? QuestionsViewController
        
        getScansList()
        getSurveyList()
        
    }
    
    func getScansList(){
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            let text = "SELECT * FROM scans WHERE patient_id = \(Patient.id!) ORDER BY id DESC"
            defer {db.statment?.close()}
            
            let cursor = db.execute(text: text)
            
            defer {cursor.close()}
            
            for (row) in cursor {
                let columns = try row.get().columns
                var prop_C = try columns[2].double()
                var prop_T = try columns[3].double()
                var prop_L = try columns[4].double()
                var dl_C = try columns[5].double()
                var dl_T  = try columns[6].double()
                var dl_L = try columns[7].double()
                let id = try columns[0].int()
                let patient_id = try columns[1].int()
                let time_stamp = try columns[8].string()
                var lean = try columns[9].double()
                scanslist += createArray(id: id, prop_C: prop_C, prop_T: prop_T, prop_L: prop_L, dl_C: dl_C, dl_T: dl_T, dl_L: dl_L, time_stamp: time_stamp, lean: lean)
                print(id)
            }
           
        } catch {
            print(error)
        }
    }
    
    func getSurveyList() {
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            let text = "SELECT * FROM survey WHERE patient_id = \(Patient.id!) ORDER BY id DESC"
            defer {db.statment?.close()}
            
            let cursor = db.execute(text: text)
            
            defer {cursor.close()}
            
            for (row) in cursor {
                let columns = try row.get().columns
                let score = try columns[2].int()
                let time_stamp = try columns[3].string()
                surveylist += createSurveyArray(score: score, time_stamp: time_stamp)
            }
        } catch {
            print(error)
        }
        }
    
    func createArray(id: Int, prop_C: Double, prop_T: Double, prop_L: Double, dl_C: Double, dl_T: Double, dl_L: Double, time_stamp: String, lean: Double) -> [PatientScan] {
        var tempList: [PatientScan] = []
        let list = PatientScan(id: id, time_stamp: time_stamp, prop_C: prop_C, prop_T: prop_T, prop_L: prop_L, dl_C: dl_C, dl_T: dl_T, dl_L: dl_L, lean: lean)
        tempList.append(list)

        return tempList
        
    }
    
    func createSurveyArray(score: Int, time_stamp: String) -> [QuestionsScore] {
        var tempList: [QuestionsScore] = []
        let list = QuestionsScore(score: score, time_stamp: time_stamp)
        tempList.append(list)
        
        return tempList
    }
    
    
}

extension PatientProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == self.tableView ? scanslist.count:surveylist.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        if tableView == self.tableView {
            let scan = scanslist[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScansCell") as! ScansTableViewCell
            cell.setScans(scans: scan)
            returnCell = cell
        } else {
            let survey = surveylist[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyCell") as! SurveyTableViewCell
            cell.setSurvey(survey: survey)
            returnCell = cell
        }
        
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView {
            let selectedScan = scanslist[indexPath.row]
            let format = NumberFormatter()
            format.minimumFractionDigits = 2
            format.maximumFractionDigits = 2
            
            cervical.text = format.string(for: (selectedScan.prop_C! * 100))! + "%"
            thoracic.text = format.string(for: (selectedScan.prop_T! * 100))! + "%"
            lumbar.text = format.string(for: (selectedScan.prop_L! * 100))! + "%"
            lean.text =  format.string(for: selectedScan.lean)
            spin_pic.loadFrom(URLAddress: "http://52.90.36.209:8000/media/\(selectedScan.id).png")
        } else {
            let selectedSurvey = surveylist[indexPath.row]
            survey_score.text = String(selectedSurvey.score)
        }
    }
    
}

extension UIImageView {
    
    func loadFrom(URLAddress: String) {
            guard let url = URL(string: URLAddress) else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                if let imageData = try? Data(contentsOf: url) {
                    if let loadedImage = UIImage(data: imageData) {
                            self?.image = loadedImage
                    }
                }
            }
        }
    
}

