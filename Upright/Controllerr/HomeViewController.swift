//
//  HomeViewController.swift
//  Upright
//
//  Created by USS - Software Dev on 3/1/22.
//

import UIKit

class HomeViewController: UIViewController {
    
   
 
    @IBOutlet weak var patient_delta: UILabel!
    @IBOutlet weak var patientCount: UILabel!
    @IBOutlet weak var scanCount: UILabel!
    
    
    static let homeViewController = "HomeVC"
    var homeview: HomeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeview = HomeView()
        getClinicScores()
        
    }
    
    func getPatients(){
        
    }
    
    func getClinicScores(){
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            let text = "select (SELECT COUNT(id) as \"patientTotal\" FROM scans WHERE organization_id = \(Organization.id!)) patientTotal, (SELECT COUNT(id) as \"scanTotal\" FROM patient WHERE provider_id = \(Organization.id!)) scanTotal"
            defer {db.statment?.close()}
            
            let cursor = db.execute(text: text)
            
            defer {cursor.close()}
            
            for (row) in cursor {
                let columns = try row.get().columns
                
                let patientTotal = try columns[1].int()
                let scanTotal = try columns[0].int()
                setData(scans: scanTotal, patients: patientTotal)
            }
        } catch {
            print(error)
        }
    }
    
    func setData(scans: Int, patients: Int){
        patientCount.text = String(patients)
        scanCount.text = String(scans)
    }
    
    
}
