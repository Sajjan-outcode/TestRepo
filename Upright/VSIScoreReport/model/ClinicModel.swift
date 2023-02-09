//
//  ClinicModel.swift
//  Upright
//
//  Created by Sajjan on 08/02/2023.
//

import Foundation

struct ClinicModel {
    var name: String
    var address: String
    var phone: String
    var email: String
    
    init(name: String, address: String, phone: String, email: String) {
        self.name = name
        self.address = address
        self.phone = phone
        self.email = email
    }
    
}
