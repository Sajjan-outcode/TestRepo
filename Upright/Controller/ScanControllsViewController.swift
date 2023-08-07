//
//  ScanControllsViewController.swift
//  Upright
//
//  Created by USS - Software Dev on 3/24/22.
//
import Foundation
import UIKit
import CoreBluetooth



var linkTheScan = false
var scanId:Int?
let bleManager: BLEManager = BLEManager()


class ScanControllsViewController: UIViewController {
    
    var mainView: BaseViewController!
    
    var get_status: String = "Status!"
    var x_y_String: String? = ""
    var X_YArray:[[Int]] = []
    var x = 1
    var oneMinTimer = Timer()
    var oneSecTimer = Timer()
    var scans: ScanController!
    
    var results:[String] = []
    var scanResults: [ScanController.ScanResults] = [] as! [ScanController.ScanResults]
    var current_index = 1
    var scanTotal: Int = 0
    // var BaseViewController: BaseViewController!
    var displayError: Bool? = false
    let defualts = UserDefaults.standard
    var settings: Settings?
    private var patientlist: [PatientSearch] = []
    var filteredData:[PatientSearch]!
    var filteredScanHistory:[PatientScan]!
    var session = URLSession.shared
    var scanHistory: [PatientScan] = []
    var patientHeight: Double?
    var sendIndexComplete: Bool = false
    
   
    var patientView: PatientProfileViewController!
    
    
    
    @IBOutlet weak var ScanHistoryTable: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: RoundImageView!
    
    
    @IBOutlet weak var connect_B: UIButton!
    
    @IBOutlet weak var scan_id: UILabel!
    
    @IBOutlet weak var scanInfoMainView: UIView!
    
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var lean_value: UILabel!
    
    @IBOutlet weak var p_c: UILabel!
    @IBOutlet weak var t_c: UILabel!
    
    @IBOutlet weak var p_t: UILabel!
    @IBOutlet weak var t_t: UILabel!
    
    @IBOutlet weak var p_l: UILabel!
    @IBOutlet weak var t_l: UILabel!
    
    @IBOutlet weak var n_c: UILabel!
    @IBOutlet weak var nt_c: UILabel!
    
    @IBOutlet weak var n_t: UILabel!
    @IBOutlet weak var nt_t: UILabel!
    
    @IBOutlet weak var n_l: UILabel!
    @IBOutlet weak var nt_l: UILabel!
    
    @IBOutlet weak var spinePic: UIImageView!
    @IBOutlet weak var sagittal_score: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scanHisSearchBar: UISearchBar!
    
    @IBOutlet weak var LinkScanView: RoundImageView!
    
    @IBOutlet weak var ScanHistoryView: RoundImageView!
    @IBOutlet weak var DeviceSettingsView: RoundImageView!
    
    @IBOutlet weak var PressureValue: UISlider!
    @IBOutlet weak var ProbValue: UISegmentedControl!
    @IBOutlet weak var DeviceHeightValue: UILabel!
    @IBOutlet weak var DeviceSpeedValue: UISlider!
    
    @IBOutlet weak var start_b: UIButton!
    @IBOutlet weak var stop_b: UIButton!
    @IBOutlet weak var sdsScore: UILabel!
    
    @IBOutlet weak var next_B: UIButton!
    
    @IBOutlet weak var patienProfileButton: UIButton!
    
    @IBAction func errorButton(_ sender: Any) {
        errorView.isHidden = true
    }
    
    @IBAction func DeviceSettings(_ sender: Any) {
        if(bleManager.isConnected() != false){
            DeviceSettingsView.isHidden = false
        }else{
            
        }
    }
    
    @IBAction func SubmitDeviceSettings(_ sender: Any) {
        DeviceSettingsView.isHidden = true
        let pressure = PressureValue.value
        let probType = ProbValue.selectedSegmentIndex
        let height = inchToMm(inch: DeviceHeightValue.text!)
        let speed = DeviceSpeedValue.value
        
        setLocalData(value: height, key: "deviceHeight", type: "Int")
        bleManager.sendPressure(newPressure: UInt8(pressure))
        bleManager.sendProbeType(newProbeType: UInt8(probType))
        bleManager.sendScanSpeed(newScanSpeed: UInt8(speed))
        bleManager.sendDeviceHeight(newDeviceHeight:  height)
       
    }
    
    @IBAction func StraightorAngle(_ sender: UISegmentedControl) {
        var prob = sender.selectedSegmentIndex
        // print(prob)
    }
    
    @IBAction func pressure(_ sender: UISlider) {
        
    }
    
    @IBAction func Initialize(_ sender: Any) {
        start_b.isHidden = false
        stop_b.isHidden = true

        if bleManager.isConnected() {
            bleManager.sendCommand(newCommand: 2)
        }
        
        if(!bleManager.isConnected()){
            self.connect_B.isEnabled = true
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        patientHeight = Double(bleManager.getHeight())
        getX_Y()
        start_b.isHidden = false
        stop_b.isHidden = true
        patienProfileButton.isEnabled = true
        self.getHeight()
        
    }
    
    @IBAction func Detect_Patient(_ sender: Any) {
        bleManager.sendCommand(newCommand: 3)
    }
    
  
    @IBOutlet weak var HomeVsi: UIButton!
    
    @IBAction func Start_Scan(_ sender: Any) {
        bleManager.sendCommand(newCommand: 4)
        start_b.isHidden = true
        stop_b.isHidden = false
    }
    
    @IBAction func Stop_Scan(_ sender: Any) {
        bleManager.sendCommand(newCommand: 5)
        start_b.isHidden = false
        stop_b.isHidden = true
        
    }
    
    @IBAction func Connect(_ sender: Any) {
        bleManager.connect()
        //print(bleManager.isConnected())
        print(bleManager.isConnected())
    }
    

    @IBAction func nextscan(_ sender: Any) {
        moveScanResultsIndex(move_index: "minus")
       
    }
    
    @IBAction func linkScan(_ sender: Any) {
       // linkScan()
        if(qScan == false){
        LinkScanView.isHidden = false
        linkTheScan = true
        }
    }
    
    @IBAction func LinkScanOkButton(_ sender: Any) {
        LinkScanView.isHidden = true
        
    }
    
    
    @IBOutlet weak var previous_B: UIButton!
    
    @IBAction func previous_Scan(_ sender: Any) {
        moveScanResultsIndex(move_index: "plus")
    }
    
    @IBAction func ScanHistory(_ sender: Any) {
        getScanHistory()
        ScanHistoryTable.reloadData()
        ScanHistoryView.isHidden = false
    }
    
    @IBAction func ScanHistoryOkButton(_ sender: Any) {
        ScanHistoryView.isHidden = true
    }
    
    @IBOutlet weak var profileText: UILabel!
    @IBOutlet weak var clearProfileButton: UIButton!
    
    @IBAction func clearProfile(_ sender: Any) {
      clearProfileId()
    }
    
    @IBOutlet weak var profileName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getScanHistory()
        getPatientList()
        setProfileName()
        checkBlueConnectionStatus()
        filteredData = patientlist
        filteredScanHistory = scanHistory
        searchBar.delegate = self
        scanHisSearchBar.delegate = self
        if(qScan == false){
        tableView.delegate = self
        tableView.dataSource = self
        }
        ScanHistoryTable.delegate = self
        ScanHistoryTable.dataSource = self
        
        self.scans = ScanController()
       
        mainView = storyboard?.instantiateViewController(withIdentifier: "BaseViewController") as? BaseViewController
        patientView = storyboard?.instantiateViewController(withIdentifier: "PatientProfileViewController") as? PatientProfileViewController
        
        
        if((self.defualts.value(forKey: "set")) == nil) {
            setLocalData(value: true, key: "set", type: "String")
            setLocalData(value: UInt32(101.6), key: "deviceHeight", type: "Int")

        } else {
   }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        self.HomeVsi.addGestureRecognizer(longPress)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshScan(refresh: true, process: "bluetooth")
        getScanHistory()
        getPatientList()
        setProfileName()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: AppConstants.NotificationNames.didUpdateScan, object: nil)
    }
    
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            bleManager.sendCommand(newCommand: 1)
        }
    }
    @IBAction func onClickPatientProfile(_ sender: Any) {
            present(mainView!, animated: false)
            mainView!.setView(currentView: patientView!.view)
            mainView.displayContentController(content: patientView)
        
    }
    

    func checkBlueConnectionStatus(){
        
        
        oneMinTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true, block: { _ in
            if(bleManager.isConnected()){
                self.connect_B.isEnabled = false
                self.connect_B.setTitle("Connected", for: .normal)
                
            }else{
                bleManager.connect()
                self.connect_B.isEnabled = true
                self.connect_B.setTitle("Connect", for: .normal)
            }
            
        })
        
    }
    
    func setLocalData(value: Any, key: String, type: String){
        
        switch type {
        case "Int":
            self.defualts.set(value, forKey: key)
            
        case "String":
            self.defualts.set(value, forKey: key)
        
        default:
            print("Great Work")
        }
        
        
    }
    
    func setProfileName(){
        if(Patient.id != nil){
            patienProfileButton.isHidden = false
            patienProfileButton.isEnabled = false
            profileText.isHidden = false
            profileName.isHidden = false
            clearProfileButton.isHidden = false
            profileName.text = Patient.first_name! + " " + Patient.last_name!
        } else {
            
            patienProfileButton.isHidden = true
        }
    }
    
    func clearProfileId(){
        Patient.id = nil
        profileText.isHidden = true
        profileName.isHidden = true
        clearProfileButton.isHidden = true
        patienProfileButton.isHidden = true
        
    }
    
    private func setDefualtSettings(pressure: Int, type: Int, height: Int, speed: Int){
        PressureValue.value = Float(pressure)
        ProbValue.selectedSegmentIndex = Int(type)
        DeviceHeightValue.text =  String(height)
        DeviceSpeedValue.value = Float(speed)
    }
    
    func getPatientList() {
        let patients = Patients(organization: Organization.id!)
        patientlist = patients.getPatients()
    }
    
    func getScanHistory(){
        let scans = Scans()
        scanHistory =  scans.getUnlinkedScans()
    }
    
    func callHttp() {
        refreshScan(refresh: false, process: "")
        // clear scanresults
        self.scanResults = []
        // Create URL
        let url = URL(string: "http://\(db.host!)?id=\(Organization.id!)")
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
                
                if(response.statusCode != 200){
                    self.displayError = true
                }
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                
                do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                        let scan = json?["scan"] as? [[String: Any]] ?? []
                    
                    for result in scan{
                        let tempScanArray = ScanController.ScanResults(id: result["id"] as! String ,p_c: result["p_c"]! as! Double, p_t: result["p_t"]! as! Double, p_l: result["p_l"]! as! Double, d_c: result["d_c"]! as! Double, d_t: result["d_t"]! as! Double, d_l: result["d_l"]! as! Double, lean: result["lean"]! as! Double)
                        self.scanResults.append(tempScanArray)
                        NotificationCenter.default.post(name: AppConstants.NotificationNames.didUpdateScan,
                                                        object: nil)
                                                 
                    }
                    } catch {
                        print(error)
                    }
                
            }
         
        }

        task.resume()

        self.refreshScan(refresh: true, process: "awsresponse")
        
    }
    
    
    func refreshScan(refresh: Bool, process: String){
        
        
        if(refresh){
            oneSecTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                
                var x_array = bleManager.getX_array().count
                var vsiArrayCount = bleManager.getLength()

                if(!self.displayError!){
                    switch (process) {
                    case "bluetooth":
                        if(bleManager.isConnected()){
                            self.connect_B.isEnabled = false
                            self.connect_B.setTitle("Connected", for: .normal)
                            self.refreshScan(refresh: false, process: "")
                        }else{
                            bleManager.connect()
                            self.connect_B.isEnabled = true
                            self.connect_B.setTitle("Connect", for: .normal)
                        }
                    case "submitscan":
                        if(self.sendIndexComplete && x_array == vsiArrayCount){
                            
                            let X_s = bleManager.getX_array()
                            let Y_s = bleManager.getY_array()
                            //print(X_s.count)
                            //print("second" + String(self.bleManager.getX_array().count))
                            for x in 0...x_array - 1{
                                if(X_s[x] != 0){
                                self.X_YArray.append([X_s[x],Y_s[x]])
                                }
                            }
                            self.insertX_Y()
                            self.callHttp()
                        }
                    case "awsresponse":
                        if(!self.scanResults.isEmpty){
                        self.setNumbers(index: self.scanTotal)
                        }
                    default:
                        ""
                    }
                    
                }
                else{
                    self.displayErr()
                }
            })
        }
        else {
            oneSecTimer.invalidate()
        }
    }
    
    
    func insertX_Y(){
        
        var patient_id = ""
        var patient_value = ""
        if(Patient.id != nil){
            patient_id = "patient_id,"
            patient_value = "'\(Patient.id!)',"
        }
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            let text = "INSERT INTO Scans (\(patient_id)scans,date_stamp,organization_id,height, time_stamp) VALUES (\(patient_value)ARRAY\(self.X_YArray),current_date,\(Organization.id!),\(patientHeight!), current_time)"
            defer {db.statment?.close()}

            let cursor = db.execute(text: text)

            defer {cursor.close()}

            } catch {
            print(error)
            }
//        NotificationCenter.default.post(name: AppConstants.NotificationNames.didUpdateScan, object: nil)
    }
    
    func getX_Y() {
        self.showSpinner(onView: scanInfoMainView)
        self.X_YArray = []
        bleManager.clearArray()
        let get_length = bleManager.getLength()

        for x in 0...get_length - 1 {

            bleManager.sendScanIndex(newIndex: x)
            if(x == get_length - 1){
                sendIndexComplete = true
 //               print(get_length - 1)
//                print(String(x) + " this is x")
                refreshScan(refresh: true, process: "submitscan")
                
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){ [self] in
        }
    }
    
        
    
    func getHeight(){
       // if(bleManager.getStateString() == "Detected"){
            let mm = Double(bleManager.getHeight())
            let toFeet = mm * 0.0032808
            let feet = toFeet.splitAtDecimal()
            let inch = feet.1 * 12
            setHeight(text: "\(String(feet.0))` \(String(inch.roundTo1f()))\"")
            //timer.invalidate()
        //}
    }
    
    func setHeight(text: String){
        height.text = text
    }
    
    func setScanHistoryValues(scanHistory: PatientScan) {
        
        var sdsrisk = ""
        var pt = 0.0
        var pl = 0.0
        t_c.text = "20%"
        t_t.text = "50%"
        t_l.text = "30%"
        nt_c.text = "12%"
        nt_t.text = "12%"
        nt_l.text = "12%"
        
        let absPC = abs(0.25 - scanHistory.prop_C!) * 100
        let absPT = abs(0.50 - scanHistory.prop_T!) * 100
        
        if((scanHistory.prop_T! * 100) > 45){
            pt = (scanHistory.prop_T! * 100)
        }else {
            pt = 45
        }
        let scorePT = pt - 45
      if((scanHistory.prop_L! * 100) < 30){
            pl = (scanHistory.prop_L! * 100)
        }else{
            pl = 30
        }
        
        let scorePL = 30 - pl
        let absPL = abs(0.30 - scanHistory.prop_L!) * 100
        let sumP = absPC + absPT + absPL
        
        let absNC = abs(0.12 - scanHistory.dl_C!) * 100
        let absNT = abs(0.12 - scanHistory.dl_T!) * 100
        let absNL = abs(0.12 - scanHistory.dl_L!) * 100
        let sumD = absNC + absNT + absNL
        
        var partOne: Double = 0
        
        if((scanHistory.prop_L! * 100) < 30){
            partOne = 30 - (scanHistory.prop_L! * 100)
        }
        
        let partTwo = abs(8 - (scanHistory.dl_L! * 100))
       
        guard let leanValue = scanHistory.lean else {return}
        // s_i_score = VSIScore , 
        let s_i_Score = absPC + scorePT + scorePL + sumD + abs(leanValue)
        let sdsScore = abs(leanValue) + (partOne) + (partTwo)
        
        if(sdsScore < 15){
            sdsrisk = "Low/Moderate"
        }else{
            sdsrisk = "High"
        }
        
        scanId = scanHistory.id
        self.scan_id.text = scanHistory.id.flatMap(String.init)
        self.p_c.text = "\(scans.formatString(number: scanHistory.prop_C!))%"
        self.p_t.text = "\(scans.formatString(number: scanHistory.prop_T!))%"
        self.p_l.text = "\(scans.formatString(number: scanHistory.prop_L!))%"
        self.n_c.text = "\(scans.formatString(number: scanHistory.dl_C!))%"
        self.n_t.text = "\(scans.formatString(number: scanHistory.dl_T!))%"
        self.n_l.text = "\(scans.formatString(number: scanHistory.dl_L!))%"
        self.lean_value.text = scans.formatLean(lean: leanValue)  + "º"
        self.sagittal_score.text = sdsrisk
        self.sdsScore.text = String(Int(s_i_Score))
        
        
        
        spinePic.loadFrom(URLAddress:"http://\(db.host!)/media/\(scanHistory.id!)-\(scanHistory.time_stamp!).png")
        
        
        
    }
    
    func setNumbers(index:Int = 0) {
        self.removeSpinner()
            
            var sdsrisk = ""
            var pt = 0.0
            var pl = 0.0
        
            t_c.text = "20%"
            t_t.text = "50%"
            t_l.text = "30%"
            nt_c.text = "12%"
            nt_t.text = "12%"
            nt_l.text = "12%"
            
            let absPC = abs(0.25 - self.scanResults[index].p_c) * 100
        print("abs " + String(absPC))
             let absPT = abs(0.45 - self.scanResults[index].p_t) * 100
            if((self.scanResults[index].p_t * 100) > 45){
                pt = (self.scanResults[index].p_t * 100)
            }else {
                pt = 45
            }
            let scorePT = pt - 45
        print("scorePT " + String(scorePT))
            if((self.scanResults[index].p_l * 100) < 30){
                pl = (self.scanResults[index].p_l * 100)
            }else{
                pl = 30
            }
            
            let scorePL = 30 - pl
        print("scorepl " + String(scorePL))
            let absPL = abs(0.30 - self.scanResults[index].p_l) * 100
            let sumP = absPC + absPT + absPL
            // print(sumP)
            
            let absNC = abs(0.12 - self.scanResults[index].d_c) * 100
            let absNT = abs(0.12 - self.scanResults[index].d_t) * 100
            let absNL = abs(0.12 - self.scanResults[index].d_l) * 100
            let sumD = absNC + absNT + absNL
            print("sumd " + String(sumD))
            var partOne: Double = 0
        
            if((self.scanResults[index].p_l * 100) < 30){
            partOne = 30 - (self.scanResults[index].p_l * 100)
            }
        
            let partTwo = abs(8 - (self.scanResults[index].d_l * 100))
       
            let s_i_Score = absPC + scorePT + scorePL + sumD + abs(self.scanResults[index].lean)  //(self.scanResults[index].lean * self.scanResults[index].lean) + sumP + sumD
            let sdsScore = abs(self.scanResults[index].lean) + (partOne) + (partTwo)
        
        if(sdsScore < 15){
            sdsrisk = "Low/Moderate"
        }else{
            sdsrisk = "High"
        }
        
            let idStringSplit = self.scanResults[index].id.components(separatedBy: "-")
            scanId = Int(idStringSplit[0])
            self.scan_id.text = String(idStringSplit[0])
            self.p_c.text = "\(scans.formatString(number: self.scanResults[index].p_c))%"
            self.p_t.text = "\(scans.formatString(number: self.scanResults[index].p_t))%"
            self.p_l.text = "\(scans.formatString(number: self.scanResults[index].p_l))%"
            self.n_c.text = "\(scans.formatString(number: self.scanResults[index].d_c))%"
            self.n_t.text = "\(scans.formatString(number: self.scanResults[index].d_t))%"
            self.n_l.text = "\(scans.formatString(number: self.scanResults[index].d_l))%"
            
            self.lean_value.text = scans.formatLean(lean: self.scanResults[index].lean) + "º"
            
            self.sagittal_score.text = sdsrisk
            self.sdsScore.text = String(Int(s_i_Score))
            
            
            spinePic.loadFrom(URLAddress: "http://\(db.host!)/media/\(self.scanResults[index].id).png")
            
            self.refreshScan(refresh: false, process: "")
            
            
        
    }
    
    func linkScanToPatient(patient_Id: Int, scan_Id: Int){
        
        let database: db = db()
        defer {database.connection?.close()}
        let text = "UPDATE scans SET patient_id = \(patient_Id) WHERE id = \(scan_Id)"
        let result = database.execute(text: text)
        
    }
    
    
    func displayErr(){
        self.removeSpinner()
        self.errorView.isHidden = false
        self.refreshScan(refresh: false, process: "")
        self.displayError = false
    }
    
    func moveScanResultsIndex(move_index: String){
//        if(current_index >= 0 && current_index <= scanResults.count){
//            switch move_index {
//            case "plus":
//                self.current_index += 1
//                setNumbers(index: self.current_index)
//            case "minus":
//                self.current_index -= 1
//                setNumbers(index: self.current_index)
//            default:
//                print("Error")
//            }
//        }
    }
    
    func mmToInch(mm: Float) -> Float{
        let value = mm / 25.4
        return value
    }
    
    func inchToMm(inch: String) -> UInt32 {
        let value = Float(inch)! * 25.4
        return UInt32(value)
    }
    
}

var vSpinner : UIView?


extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

extension ScanControllsViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableView == self.tableView ? filteredData.count:filteredScanHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        
        if tableView == self.tableView{
        let patient = filteredData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ControllerViewCell") as! ControllerTableViewCell
        cell.setCellLabels(name: patient.first_name + " " + patient.last_name, dob: patient.email as! String)
        returnCell = cell
        } else {
            let scan = filteredScanHistory[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScanHistoryCell") as! scanHistoryTableViewCell
            let splitDateandTime = scan.time_stamp?.components(separatedBy: " ")
            let date = splitDateandTime![0]
            let name = scan.first_name! + " " + scan.last_name!
            let id = scan.id
            //let time = splitDateandTime![1]
            let time = "00:00:00"
            cell.setScanHistory(ScanDate: date, ScanTime: time, ScanId: id!, ScanPatientName: name)
            returnCell = cell
        }
    
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView{
            let selectedPatient = filteredData[indexPath.row]
            Patient.id = selectedPatient.id
            Patient.provider_id = selectedPatient.provider_id
            Patient.first_name = selectedPatient.first_name
            Patient.last_name = selectedPatient.last_name
            // Patient.date_of_birth = selectedPatient.dob
            Patient.email = selectedPatient.email
            Patient.address = selectedPatient.address
            Patient.city = selectedPatient.city
            Patient.state = selectedPatient.state
            Patient.zip = selectedPatient.zip
            Patient.phone_number = selectedPatient.phone_number
        if(scanId != nil){
            linkScanToPatient(patient_Id: Patient.id!, scan_Id: scanId!)
        }
        // mainView?.CurrentView.addSubview(patientView!.view)
        present(mainView!, animated: false)
        mainView!.setView(currentView: patientView!.view)
            mainView.displayContentController(content: patientView)
        } else {
            let scanHistory = filteredScanHistory[indexPath.row]
            setScanHistoryValues(scanHistory: scanHistory)
            ScanHistoryView.isHidden = true
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.tag == 1 {
        filteredScanHistory = []
        }else if searchBar.tag == 2{
        filteredData = []
        }
        
        if searchBar.tag == 1 {
            
        if searchText == "" {
            filteredData = patientlist
        } else {
            for patient in patientlist {
                if patient.first_name.uppercased().contains(searchText.uppercased()) {
                    filteredData.append(patient)
                }
            }
            
        }
            
        }else if searchBar.tag == 2 {
            if searchText == "" {
                filteredScanHistory = scanHistory
            } else {
                for scan in scanHistory {
                    if String(scan.id).uppercased().contains(searchText.uppercased()){
                   // if patient.first_name.uppercased().contains(searchText.uppercased()) {
                       // filteredData.append(patient)
                  //  }
                    filteredScanHistory.append(scan)
                    }
                }
            }
            
            
        }
        if searchBar.tag == 1{
            self.tableView.reloadData()
        
        }else if searchBar.tag == 2{
            self.ScanHistoryTable.reloadData()
        }
        
    }
    
    
}



