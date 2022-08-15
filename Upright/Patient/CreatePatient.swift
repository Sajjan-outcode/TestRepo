//
//  CreatePatient.swift
//  Upright
//
//  Created by USS - Software Dev on 3/4/22.
//

import Foundation
import UIKit

class CreatePatient: UIViewController {
    
   // var AppViewController: AppViewController?
    var mainView:MainViewController?
    var patientView: PatientProfileViewController?
    var scanController: ScanControllsViewController?
    var patientSearchView: PatientSearchViewController?
    
    @IBOutlet weak var First_Name: UITextField!
    @IBOutlet weak var Last_Name: UITextField!
   
    @IBOutlet weak var CreatePatientDatePicker: UIDatePicker!
    @IBOutlet weak var Email: UITextField!
    
    @IBAction func Cancel(_ sender: Any) {
        
        mainView!.setView(currentView: (patientSearchView?.view)!)
        
    }
    
    @IBAction func Create(_ sender: Any) {
        
        submitData()
        getPatient()
        if(linkTheScan == true){
            scanController?.linkScanToPatient(patient_Id: Patient.id!, scan_Id: scanId!)
        }
        
        present(mainView!, animated: false)
        mainView!.setView(currentView: patientView!.view)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        patientView = storyboard?.instantiateViewController(withIdentifier: "PatientProfileViewController") as? PatientProfileViewController
        patientSearchView = storyboard?.instantiateViewController(withIdentifier: "PatientSearchViewController") as? PatientSearchViewController
        scanController = ScanControllsViewController()
    }
    
    func submitData() {
        let database: db = db()
        defer {database.connection?.close()}
        let text = "INSERT INTO patient (provider_id, first_name, last_name, date_of_birth, email_address) VALUES (\(Organization.id!),'\(First_Name.text!)','\(Last_Name.text!)','\(CreatePatientDatePicker.date)','\(Email.text!)')"
        let result = database.execute(text: text)

            print(result)

    }
    
    func getPatient(){
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            let text = "SELECT patient.id, provider_id, first_name, last_name, email_address, CAST(date_of_birth AS VARCHAR) FROM patient WHERE provider_id = 1 AND last_name = '\(Last_Name.text!)' AND first_name = '\(First_Name.text!)'"
            defer {db.statment?.close()}
            
            let cursor = db.execute(text: text)
            
            defer {cursor.close()}
            
            for (row) in cursor {
                let columns = try row.get().columns
                let id = try columns[0].int()
                let provider_id = try columns[1].int()
                let first_name = try columns[2].string()
                let last_name = try columns[3].string()
                let dob = try columns[5].string()
                let email = (try? columns[4].string()) ?? "aa"
                let address = "NA"
                let city = "NA"
                let state = "NA"
                let zip = "NA"
                let phone_number = "NA"
                
                Patient.id = id
                Patient.first_name = first_name
                Patient.last_name = last_name
                Patient.date_of_birth = dob
                Patient.email = email
                Patient.address = address
                Patient.city = city
                Patient.state = state
                Patient.zip = zip
                Patient.phone_number = phone_number
            }
        } catch {
            print(error)
        }
    }
    
}
