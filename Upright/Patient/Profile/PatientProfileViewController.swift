//
//  PatientProfileViewController.swift
//  Upright
//
//  Created by USS - Software Dev on 3/10/22.
//

import UIKit
import SwiftUI


class PatientProfileViewController: UIViewController {
    
    let submitEmail = false
    let date  = Date()
    
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
    @IBOutlet weak var EmailView: RoundImageView!
    @IBOutlet weak var EmailViewInput: UITextField!
    @IBOutlet weak var normalityCervical: UILabel!
    @IBOutlet weak var normalityThoracic: UILabel!
    @IBOutlet weak var normalityLumbar: UILabel!
    @IBOutlet weak var Height: UILabel!
    @IBOutlet weak var ConfirmEmailTxt: UILabel!
    @IBOutlet weak var EmailConfirmTitle: UILabel!
    @IBOutlet weak var resultsId: UILabel!
    
    var pic_date:String!
    var vsiReportViewmodel: VSIReportViewModel!
    
    @IBOutlet weak var EmailConfirmInputBox: UITextField!
    
    
    @IBAction func ReferPatient(_ sender: Any) {
        if let url = NSURL(string: "https://www.uprightspine.com/booking-calendar/virtual-consultation-free?referral=service_list_widget"){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @IBAction func ReferralEmailBtn(_ sender: Any) {
        EmailView.isHidden = false
        ConfirmEmailTxt.text = Patient.email
    }
    
    @IBAction func EmailViewOkButton(_ sender: Any) {
        let email: String
        if(EmailConfirmInputBox.text != ""){
            email = EmailConfirmInputBox.text!
            self.patient.updateEmailAddress(email: email)
            self.email.text = email
        }else{
            email = Patient.email!
        }
        callHttp(email: email)
        EmailView.isHidden = true
    }
    
    @IBAction func EditEmailBtn(_ sender: Any) {
        editEmail()
    }
    
    @IBAction func viewReport(_ sender: Any) {
        initVSIReportViewcontroller()
    }
    
    @IBAction func New_Scan(_ sender: Any) {
        present(mainView!, animated: false, completion: nil)
        mainView.displayContentController(content: scanView!)
    }
    @IBAction func New_Survey(_ sender: Any) {
        present(mainView!, animated: false, completion: nil)
        mainView.displayContentController(content: questionView!)
    }
    
    @IBAction func ReferralEmailCancel(_ sender: Any) {
        EmailView.isHidden = true
    }
    
    
    var patient_id:Int?
    var scanslist: [PatientScan] = []
    var surveylist: [QuestionsScore] = []
    
    var mainView: BaseViewController!
    var scanView: ScanControllsViewController?
    var questionView: QuestionsViewController?
    var scans: ScanController!
    var patient: Patient!
    var calc: Calculations?
    
    @IBOutlet weak var vsiReportBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        surveyTableView.delegate = self
        surveyTableView.dataSource = self
        
        patient = Patient()
        
        self.scans = ScanController()
        name.text = Patient.first_name! + " " + Patient.last_name!
        email.text = Patient.email
        self.patient_id = Patient.id!
        
        mainView = storyboard?.instantiateViewController(withIdentifier: "BaseViewController") as? BaseViewController
        scanView = storyboard?.instantiateViewController(withIdentifier: "ScanControllsViewController") as? ScanControllsViewController
        questionView = storyboard?.instantiateViewController(withIdentifier: "QuestionsViewController") as? QuestionsViewController
        
        getScansList()
        getSurveyList()
        self.vsiReportBtn.isHidden = false
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateScanObserver),
                                               name: AppConstants.NotificationNames.didUpdateScan,
                                               object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(row: 0, section: 0)
        if(!scanslist.isEmpty){
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
        if(!surveylist.isEmpty){
            surveyTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            surveyTableView.delegate?.tableView?(surveyTableView, didSelectRowAt: indexPath)
        }
        
    }
    
    
    @IBAction func onAttachmentBtnPress(_ sender: Any) {
        let patientAttachmentController = PatientAttachmentViewController()
        patientAttachmentController.modalPresentationStyle = .overFullScreen
        self.present(patientAttachmentController, animated: true)
        
    }
    
    
    func initVSIReportViewcontroller() {
        let vsiReportViewModel = VSIReportViewModel(patientId: Patient.id!,
                                                    vsiReportInfoModel: VSIReportInfoModel.getNewVSIReportInfoModel(),
                                                    patientScanList: scanslist,
                                                    surveyList: surveylist)
        let vsiController = VSIReportController()
        vsiController.viewModel = vsiReportViewModel
        vsiController.modalPresentationStyle = .fullScreen
        self.present(vsiController, animated: true)
        
    }
    
    @objc private func updateScanObserver() {
        getScansList()
        getSurveyList()
        tableView.reloadData()
    }
    
    
    func getScansList(){
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            let text = "SELECT *, to_char(date_stamp, 'mm/dd/yyyy') as scan_date, to_char(time_stamp, 'HH24:MI') as time_stamp FROM scans WHERE patient_id = \(Patient.id!) AND lean IS NOT NULL ORDER BY id DESC "
            defer {db.statment?.close()}
            
            let cursor = db.execute(text: text)
            
            defer {cursor.close()}
            for (row) in cursor {
                let columns = try row.get().columns
                let prop_C = try columns[2].double()
                let  prop_T = try columns[3].double()
                let  prop_L = try columns[4].double()
                let  dl_C = try columns[5].double()
                let  dl_T  = try columns[6].double()
                let  dl_L = try columns[7].double()
                let id = try columns[0].int()
                let patient_id = try columns[1].int()
                let time_stamp = try columns[12].optionalString()
                let date_stamp = try columns[14].string()
                let lean = try columns[9].double()
                let height = try columns[13].double()
                let pic_date = try columns[8].string()
                
                var scanDate:[String] = []
                if let timeStamp = time_stamp,
                   let formattedTimeStamp = Date.getDateTimeString(from: timeStamp, with: "HH:mm:ss.SSS", to: "HH:mm") {
                    scanDate.append("\(date_stamp) \(formattedTimeStamp)")
                } else {
                    scanDate.append(date_stamp)
                }
                scanslist += createArray(id: id, prop_C: prop_C, prop_T: prop_T, prop_L: prop_L, dl_C: dl_C, dl_T: dl_T, dl_L: dl_L, time_stamp: scanDate.joined(separator: " "), lean: lean, height: height, pic_date: pic_date)
                // print(id)
            }
            
        } catch {
            print(error)
        }
    }
    
    func getSurveyList() {
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            let text = "SELECT score, to_char(time_stamp, 'mm/dd/yyyy') FROM survey WHERE patient_id = \(Patient.id!) ORDER BY id DESC"
            defer {db.statment?.close()}
            
            let cursor = db.execute(text: text)
            
            defer {cursor.close()}
            
            for (row) in cursor {
                let columns = try row.get().columns
                let score = try columns[0].int()
                let time_stamp = try columns[1].string()
                surveylist += createSurveyArray(score: score, time_stamp: time_stamp)
            }
        } catch {
            print(error)
        }
    }
    
    func createArray(id: Int, prop_C: Double, prop_T: Double, prop_L: Double, dl_C: Double, dl_T: Double, dl_L: Double, time_stamp: String, lean: Double, height: Double, pic_date: String) -> [PatientScan] {
        var tempList: [PatientScan] = []
        let list = PatientScan(first_name: Patient.first_name!, last_name: Patient.last_name!, id: id, time_stamp: time_stamp, prop_C: prop_C, prop_T: prop_T, prop_L: prop_L, dl_C: dl_C, dl_T: dl_T, dl_L: dl_L, lean: lean, height: height, pic_date: pic_date)
        tempList.append(list)
        
        return tempList
        
    }
    
    func createSurveyArray(score: Int, time_stamp: String) -> [QuestionsScore] {
        var tempList: [QuestionsScore] = []
        let list = QuestionsScore(score: score, time_stamp: time_stamp)
        tempList.append(list)
        
        return tempList
    }
    
    func editEmail(){
        EmailConfirmTitle.text = "Please Re-enter Email Address"
        ConfirmEmailTxt.isHidden = true
        EmailConfirmInputBox.isHidden = false
    }
    
    func callHttp(email: String) {
        
        
        // Create URL
        let url = URL(string: "http://\(db.host!)?type=sendemail&email=\(email)")
        var scanArray: [ScanController.ScanResults]
        guard let requestUrl = url else { fatalError() }
        
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                
            }
            
        }
        
        task.resume()
        
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
            
            resultsId.text = String(selectedScan.id)
            cervical.text = scans.formatString(number: selectedScan.prop_C!) + "%"
            thoracic.text = scans.formatString(number: selectedScan.prop_T!) + "%"
            lumbar.text = scans.formatString(number: selectedScan.prop_L!) + "%"
            normalityCervical.text = scans.formatString(number: selectedScan.dl_C!) + "%"
            normalityThoracic.text = scans.formatString(number: selectedScan.dl_T!) + "%"
            normalityLumbar.text = scans.formatString(number: selectedScan.dl_L!) + "%"
            lean.text =  scans.formatLean(lean: abs(selectedScan.lean!)) + "º"
            Height.text = scans.getHeight(height: selectedScan.height)
            spin_pic.loadFrom(URLAddress: "http://\(db.host!)/media/\(selectedScan.id!)-\(selectedScan.pic_date!).png")
            
            // print("http://50.16.61.116:8000/media/\(selectedScan.id!)-\(selectedScan.time_stamp!).png")
            self.segittal_index.text = "Loading..."
            self.uprightly_score.text = "Loading..."
            self.delta_score.text = "Loading..."
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                self.calc = Calculations(patient_id: Patient.id!, prop_c: selectedScan.prop_C, prop_t: selectedScan.prop_T, prop_l: selectedScan.prop_L, norm_c: selectedScan.dl_C, norm_t: selectedScan.dl_T, norm_l: selectedScan.dl_L, lean: selectedScan.lean)
                guard let calcValue = self.calc else {return}
                DispatchQueue.main.async {
                    
                    self.segittal_index.text = String(calcValue.getVsiScore())
                    self.uprightly_score.text = String(calcValue.getUprightlyScore())
                    self.delta_score.text = String(calcValue.getDeltaScore())
                }
            }
            
            
        } else {
            let selectedSurvey = surveylist[indexPath.row]
            survey_score.text = String(selectedSurvey.score)
        }
    }
    
}



