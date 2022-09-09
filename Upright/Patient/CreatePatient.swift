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
        present(mainView!, animated: false)
        mainView!.setView(currentView: (patientSearchView?.view)!)
        
    }
    
    @IBAction func Create(_ sender: Any) {
        submitData()
        getPatient()
        setPatientInfo(firstName: First_Name.text!, lastName: Last_Name.text!, dob: CreatePatientDatePicker.date, emailAddress: Email.text!)
        
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
        let text = "INSERT INTO patient (provider_id, first_name, last_name, email_address) VALUES (\(Organization.id!),'\(First_Name.text!)','\(Last_Name.text!)','\(Email.text!)')"
        let result = database.execute(text: text)

            print(result)

    }
    
    func getPatient(){
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            let text = "SELECT id FROM patient WHERE provider_id = \(Organization.id!) AND last_name = '\(Last_Name.text!)' AND first_name = '\(First_Name.text!)'"
            defer {db.statment?.close()}
            
            let cursor = db.execute(text: text)
            
            defer {cursor.close()}
            
            for (row) in cursor {
                let columns = try row.get().columns
                let id = try columns[0].int()
                
                
                Patient.id = id
               
            }
        } catch {
            print(error)
        }
    }
    
    func setPatientInfo(firstName: String, lastName: String, dob: Date, emailAddress: String){
        
        let dateFormatter = DateFormatter()
        
        Patient.first_name = firstName
        Patient.last_name = lastName
        Patient.date_of_birth = dateFormatter.string(from: dob)
        Patient.email = emailAddress

    }
    
}
