//
//  Patients.swift
//  Upright
//
//  Created by USS - Software Dev on 7/20/22.
//

import Foundation
import PostgresClientKit


class Patients {
    
    private var patientlist: [PatientSearch] = []
    
    init(organization: Int){
        getPatients(organization: organization)
    }
    
    func getPatients(organization: Int){
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            let text = "SELECT patient.id, provider_id, first_name, last_name, email_address, to_char(date_of_birth, 'dd-mm-yyyy') FROM patient WHERE provider_id = \(Organization.id!) ORDER BY last_name ASC"
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
                patientlist += createArray(id: id, provider_id: provider_id, first_name: first_name, last_name: last_name, dob: dob, email: email, address: address, city: city, state: state, zip: zip, phone_number: phone_number)
            }
        } catch {
            print(error)
        }
    }
    
    func createArray(id: Int, provider_id: Int, first_name: String, last_name:String, dob: String, email: String, address: String, city: String, state: String, zip: String, phone_number: String) -> [PatientSearch]{
    var tempList: [PatientSearch] = []
        let list = PatientSearch(id: id, provider_id: provider_id, first_name: first_name, last_name: last_name, dob: dob, email: email, address: address, city: city, state: state, zip: zip, phone_number: phone_number)
        
        tempList.append(list)
  
        return tempList
    }
    
    func getPatients() -> [PatientSearch]{
        return patientlist
    }
    
}
