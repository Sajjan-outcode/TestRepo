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



class ScanControllsViewController: UIViewController {
    
    var mainView: MainViewController?
    
    var get_status: String = "Status!"
    var x_y_String: String? = ""
    var X_YArray:[[Int]] = []
    var x = 1
    var timer = Timer()
    var scans: ScanController!


    var bleManager: BLEManager = BLEManager()
    
    var results:[String] = []
    var scanResults: [ScanController.ScanResults] = [] as! [ScanController.ScanResults]
    var current_index = 1
    var scanTotal: Int = 0
    var mainViewController: MainViewController!
    var displayError: Bool? = false
    let defualts = UserDefaults.standard
    var settings: Settings?
    private var patientlist: [PatientSearch] = []
    var filteredData:[PatientSearch]!
    var session = URLSession.shared
    var scanHistory: [PatientScan] = []
    
   
    var patientView: PatientProfileViewController?
    
    @IBOutlet weak var ScanHistoryTable: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: RoundImageView!
    
    @IBAction func errorButton(_ sender: Any) {
        errorView.isHidden = true
    }
    
    @IBOutlet weak var connect_B: UIButton!
    
    @IBOutlet weak var scan_id: UILabel!
    
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
    
    @IBOutlet weak var LinkScanView: RoundImageView!
    
    @IBOutlet weak var ScanHistoryView: RoundImageView!
    @IBOutlet weak var DeviceSettingsView: RoundImageView!
    
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
        print(speed)
        setLocalData(value: height, key: "deviceHeight", type: "Int")
        bleManager.sendPressure(newPressure: UInt8(pressure))
        bleManager.sendProbeType(newProbeType: UInt8(probType))
        bleManager.sendScanSpeed(newScanSpeed: UInt8(speed))
        bleManager.sendDeviceHeight(newDeviceHeight:  height)
       
    }
    
    @IBAction func StraightorAngle(_ sender: UISegmentedControl) {
        var prob = sender.selectedSegmentIndex
        print(prob)
    }
    @IBAction func pressure(_ sender: UISlider) {
        
    }
    
    @IBOutlet weak var PressureValue: UISlider!
    @IBOutlet weak var ProbValue: UISegmentedControl!
    @IBOutlet weak var DeviceHeightValue: UILabel!
    @IBOutlet weak var DeviceSpeedValue: UISlider!
    
   
    
    
    @IBAction func Initialize(_ sender: Any) {
        self.bleManager.sendCommand(newCommand: 2)
        if(!self.bleManager.isConnected()){
            self.connect_B.isEnabled = true
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        getX_Y()
        start_b.isHidden = false
        stop_b.isHidden = true
        
    }
    
    
    @IBAction func Detect_Patient(_ sender: Any) {
        self.bleManager.sendCommand(newCommand: 3)
        // self.scanResults = []
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.getHeight()
        })
    }
    
    @IBAction func Start_Scan(_ sender: Any) {
        self.bleManager.sendCommand(newCommand: 4)
        start_b.isHidden = true
        stop_b.isHidden = false
    }
    
    @IBAction func Stop_Scan(_ sender: Any) {
        self.bleManager.sendCommand(newCommand: 5)
        start_b.isHidden = false
        stop_b.isHidden = true
        
    }
    
    @IBOutlet weak var start_b: UIButton!
    @IBOutlet weak var stop_b: UIButton!
    
    @IBAction func Connect(_ sender: Any) {
        self.bleManager.connect()
        print(bleManager.isConnected())
    }
    
    @IBOutlet weak var next_B: UIButton!
    @IBAction func nextscan(_ sender: Any) {
        moveScanResultsIndex(move_index: "minus")
        enable_disablePreNext()
    }
    
    @IBAction func linkScan(_ sender: Any) {
       // linkScan()
        LinkScanView.isHidden = false
        linkTheScan = true
    }
    
    @IBAction func LinkScanOkButton(_ sender: Any) {
        LinkScanView.isHidden = true
        
    }
    
    @IBAction func LinkScanCreatePatientButton(_ sender: Any) {
        
    }
    
    @IBOutlet weak var previous_B: UIButton!
    
    @IBAction func previous_Scan(_ sender: Any) {
        moveScanResultsIndex(move_index: "plus")
        enable_disablePreNext()
    }
    
    @IBAction func ScanHistory(_ sender: Any) {
        ScanHistoryView.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPatientList()
        filteredData = patientlist
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // Status.text = String(bleManager.getX())
        // refreshScan(refresh: true)
 
        self.scans = ScanController()
        mainViewController = storyboard!.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        
        mainView = (storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController)!
        patientView = storyboard?.instantiateViewController(withIdentifier: "PatientProfileViewController") as? PatientProfileViewController
        
        
        if((self.defualts.value(forKey: "set")) == nil) {
            setLocalData(value: true, key: "set", type: "String")
//            self.settings = Settings(probType: 0, deviceHeight: Int32(279.4), probPressure: 1, deviceSpeed: 1)
//            setLocalData(value: 0, key: "probType")
            setLocalData(value: UInt32(101.6), key: "deviceHeight", type: "Int")
//            setLocalData(value: 1, key: "probPressure")
//            setLocalData(value: 1, key: "deviceSpeed")
//            setDefualtSettings(pressure: 1, type: 1, height: Int32(279.4), speed: 1)
        } else {
//            self.settings = Settings(probType: defualts.value(forKey: "probType") as! Int8, deviceHeight: defualts.value(forKey: "deviceHeight") as! Int32, probPressure: defualts.value(forKey: "probPressure") as! Int8, deviceSpeed: defualts.value(forKey: "deviceSpeed") as! Int8)
//            let pressure = settings?.getProbPressure()
//            let type = settings?.getProbType()
//            let height =  settings?.getDeviceHeight()
//            let speed = settings?.getDeviceSpeed()
//
//            setDefualtSettings(pressure: pressure!, type: type!, height: height!, speed: speed!)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.bleManager.connect()
//        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
//            self.getLastScan()
//        })
//        if(self.scanResults.count != 0){
//        self.setNumbers()
 //       }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            if(self.bleManager.isConnected()){
                self.connect_B.isEnabled = false
                self.connect_B.setTitle("Connected", for: .normal)
                let pressure = self.bleManager.getScanPressure()
                let speed = self.bleManager.getScanSpeed()
                let probType = self.bleManager.getProbeType()
                let height = self.defualts.integer(forKey: "deviceHeight")
                self.setDefualtSettings(pressure: Int(pressure), type: Int(probType), height: height, speed: Int(speed))
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
    
    func callHttpAsync() throws {
        
    }
    
    func callHttp() {
        // clear scanresults
        self.scanResults = []
        // Create URL
        let url = URL(string: "http://52.90.36.209:8000?id=1")
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
                     
                    }
                    } catch {
                        print(error)
                    }
                
            }
         
        }

        task.resume()

        self.refreshScan(refresh: true)
        
    }
    
    
    func refreshScan(refresh: Bool){
        if(refresh){
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                if(!self.displayError!){
                    if(!self.scanResults.isEmpty){
                    self.setNumbers(index: self.scanTotal)
                    }
                }
                else{
                    self.displayErr()
                }
            })
        }
        else {
            timer.invalidate()
        }
    }
    
   
    
    func insertX_Y(){
        var patient_id = ""
        var patient_value = ""
        if(Patient.id != nil){
            patient_id = "patient_id,"
            patient_value = "'\(Patient.id)',"
        }
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            let text = "INSERT INTO Scans (\(patient_id)scans,time_stamp,organization_id) VALUES (\(patient_value)ARRAY\(self.X_YArray),current_timestamp,'\(Organization.id!)')"
            defer {db.statment?.close()}

            let cursor = db.execute(text: text)

            defer {cursor.close()}

            } catch {
            print(error)
            }
    }
    
    func getX_Y() {
        self.showSpinner(onView: self.view)
        self.X_YArray = []
        bleManager.clearArray()
        let get_length = bleManager.getLength()

        for x in 0...get_length - 1 {

            self.bleManager.sendScanIndex(newIndex: x)

        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 10){ [self] in

            let x_length = self.bleManager.getX_array().count
            let X_s = self.bleManager.getX_array()
            let Y_s = self.bleManager.getY_array()


            for x in 0...x_length - 1{
                if(X_s[x] != 0){
                self.X_YArray.append([X_s[x],Y_s[x]])
                }
            }
            self.insertX_Y()
            callHttp()
        }
        
        
    }
    
        
    
    func getHeight(){
        if(bleManager.getStateString() == "Detected"){
            let mm = Double(bleManager.getHeight())
            let toFeet = mm * 0.0032808
            let feet = toFeet.splitAtDecimal()
            let inch = feet.1 * 12
            setHeight(text: "\(String(feet.0))` \(String(inch.roundTo1f()))\"")
            timer.invalidate()
        }
    }
    
    func setHeight(text: String){
        height.text = text
    }
    
    
    func setNumbers(index:Int = 0) {
        self.removeSpinner()
       
            t_c.text = "20%"
            t_t.text = "50%"
            t_l.text = "30%"
            nt_c.text = "12%"
            nt_t.text = "12%"
            nt_l.text = "12%"
            
            let absPC = abs(0.20 - self.scanResults[index].p_c) * 100
            let absPT = abs(0.50 - self.scanResults[index].p_t) * 100
            let absPL = abs(0.30 - self.scanResults[index].p_l) * 100
            let sumP = absPC + absPT + absPL
            
            let absNC = abs(0.12 - self.scanResults[index].d_c) * 100
            let absNT = abs(0.12 - self.scanResults[index].d_t) * 100
            let absNL = abs(0.12 - self.scanResults[index].d_l) * 100
            let sumD = absNC + absNT + absNL
            
            let s_i_Score = (self.scanResults[index].lean * self.scanResults[index].lean) + sumP + sumD
            
            let idStringSplit = self.scanResults[index].id.components(separatedBy: "-")
            scanId = Int(idStringSplit[0])
            self.scan_id.text = String(idStringSplit[0])
            self.p_c.text = "\(scans.formatString(number: self.scanResults[index].p_c))%"
            self.p_t.text = "\(scans.formatString(number: self.scanResults[index].p_t))%"
            self.p_l.text = "\(scans.formatString(number: self.scanResults[index].p_l))%"
            self.n_c.text = "\(scans.formatString(number: self.scanResults[index].d_c))%"
            self.n_t.text = "\(scans.formatString(number: self.scanResults[index].d_t))%"
            self.n_l.text = "\(scans.formatString(number: self.scanResults[index].d_l))%"
            
            self.lean_value.text = String(self.scanResults[index].lean)
            
            self.sagittal_score.text = String(s_i_Score)
            
            
            spinePic.loadFrom(URLAddress: "http://52.90.36.209:8000/media/\(self.scanResults[index].id).png")
            
            self.refreshScan(refresh: false)
            
            
        
    }
    
    func linkScanToPatient(patient_Id: Int, scan_Id: Int){
        
        let database: db = db()
        defer {database.connection?.close()}
        let text = "UPDATE scans SET patient_id = \(patient_Id) WHERE id = \(scan_Id)"
        let result = database.execute(text: text)
    }
    
    func enable_disablePreNext(){
        print(scanResults.count)
        if(scanResults.count > 1){
            if(current_index == scanResults.count){
                previous_B.isEnabled = false
            }else{
                previous_B.isEnabled = true
            }
            if(current_index == 0){
                next_B.isEnabled = false
            }else{
                next_B.isEnabled = true
            }
        }else{
            next_B.isEnabled = false
            previous_B.isEnabled = false
        }
    }
    
    func displayErr(){
        self.removeSpinner()
        self.errorView.isHidden = false
        self.refreshScan(refresh: false)
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
        
        return tableView == self.tableView ? filteredData.count:scanHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        
        if tableView == self.tableView{
        let patient = filteredData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ControllerViewCell") as! ControllerTableViewCell
        cell.setCellLabels(name: patient.first_name + " " + patient.last_name, dob: patient.dob as! String)
        } else {
            let scan = scanHistory[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScanHistoryCell") as! scanHistoryTableViewCell
            let splitDateandTime = scan.time_stamp?.components(separatedBy: " ")
            let date = splitDateandTime![0]
            let time = splitDateandTime![1]
            cell.setScanHistory(ScanDate: date, ScanTime: time)
            returnCell = cell
        }
    
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPatient = patientlist[indexPath.row]



        Patient.id = selectedPatient.id
        Patient.provider_id = selectedPatient.provider_id
        Patient.first_name = selectedPatient.first_name
        Patient.last_name = selectedPatient.last_name
        Patient.date_of_birth = selectedPatient.dob
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
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        if searchText == "" {
            filteredData = patientlist
        } else {
            for patient in patientlist {
                if patient.first_name.uppercased().contains(searchText.uppercased()) {
                    filteredData.append(patient)
                }
            }
        }
        self.tableView.reloadData()
    }
    
}



