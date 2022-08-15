//
//  PatientSearch.swift
//  Upright
//
//  Created by USS - Software Dev on 3/8/22.
//

import Foundation
import UIKit
import PostgresClientKit

class PatientSearch{
    
    var id: Int
    var provider_id: Int
    var first_name: String
    var last_name: String
    var dob: String
    var email: String
    var address: String
    var city: String
    var state: String
    var zip: String
    var phone_number: String
    
    init(id: Int, provider_id: Int, first_name: String, last_name: String,  dob: String, email: String, address: String, city: String, state: String, zip: String, phone_number: String){
        self.id = id
        self.provider_id = provider_id
        self.first_name = first_name
        self.last_name = last_name
        self.dob = dob
        self.email = email
        self.address = address
        self.city = city
        self.state = state
        self.zip = zip
        self.phone_number = phone_number
    }
}
