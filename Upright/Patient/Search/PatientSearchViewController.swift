//
//  PatientSearchViewController.swift
//  Upright
//
//  Created by USS - Software Dev on 3/7/22.
//

import UIKit
import PostgresClientKit

class PatientSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var patientlist: [PatientSearch] = []
    
    var mainView:BaseViewController!
    var patientView: PatientProfileViewController?
    var filteredData:[PatientSearch]!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getPatients()
        filteredData = patientlist
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
         mainView = storyboard?.instantiateViewController(withIdentifier: "BaseViewController") as? BaseViewController
         patientView = storyboard?.instantiateViewController(withIdentifier: "PatientProfileViewController") as? PatientProfileViewController
        
        // Do any additional setup after loading the view.
    }
    
    func getPatients(){
        let patients = Patients(organization: Organization.id!)
        patientlist = patients.getPatients()
        
    }
    
    func createArray(id: Int, provider_id: Int, first_name: String, last_name: String, dob: String, email: String, address: String, city: String, state: String, zip: String, phone_number: String) -> [PatientSearch]{
    var tempList: [PatientSearch] = []
        let list = PatientSearch(id: id, provider_id: provider_id, first_name: first_name, last_name: last_name, email: email, address: address, city: city, state: state, zip: zip, phone_number: phone_number)
        
        tempList.append(list)
  
        return tempList
    }
}

extension PatientSearchViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredData .count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let patient = filteredData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientCell") as! PatientSearchViewCell
        
        cell.setPatient(patient: patient)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPatient = patientlist[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
           
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
        
        
        
        //mainView?.CurrentView.addSubview(patientView!.view)
        //mainView.displayContentController(content: patientView!)
        present(mainView!, animated: false, completion: nil)
       // mainView!.setView(currentView: patientView!.view)
        mainView.displayContentController(content: patientView!)
        
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
