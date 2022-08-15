//
//  PatientSearchViewCell.swift
//  Upright
//
//  Created by USS - Software Dev on 3/7/22.
//

import UIKit
import PostgresClientKit

class PatientSearchViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!    
    @IBOutlet weak var dob: UILabel!
    
    func setPatient(patient: PatientSearch){
        name.text! = patient.first_name + " " + patient.last_name
        dob.text! = patient.dob
        
    }
    
}
