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
    
    private var calc: Calculations!
    static let homeViewController = "HomeVC"
    var mainView:BaseViewController!
    //var homeview: HomeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  homeview = HomeView()
       
        mainView = BaseViewController()
        calc = Calculations(patient_id: 0, prop_c: 0, prop_t: 0, prop_l: 0, norm_c: 0, norm_t: 0, norm_l: 0, lean: 0)
        getClinicScores()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        mainView.hideContentController(content: self)
//    }
    
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
        //patient_delta.text = String(calc.getTotalAvgDelta())
    }
    
    
}
