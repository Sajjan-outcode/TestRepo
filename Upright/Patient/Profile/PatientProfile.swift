//
//  PatientProfile.swift
//  Upright
//
//  Created by USS - Software Dev on 3/10/22.
//

import Foundation

class PatientProfile {
    
    var name: String
    var dob: String
    var email: String
    
    init(name: String, dob: String, email: String){
        self.name = name
        self.dob = dob
        self.email = email
    }
}
