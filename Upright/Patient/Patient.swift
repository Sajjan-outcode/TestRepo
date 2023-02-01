//
//  Patient.swift
//  Upright
//
//  Created by USS - Software Dev on 3/4/22.
//

import Foundation
import UIKit
import PostgresClientKit

struct Patient {
    
    static var id: Int?
    static var provider_id: Int?
    static var first_name: String?
    static var last_name: String?
    static var email: String?
    static var date_of_birth: String?
    static var phone_number: String?
    static var address: String?
    static var city: String?
    static var state: String?
    static var zip: String?
    
    func updateEmailAddress(email: String){
        
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            let text = "UPDATE patient SET email_address = '\(email)' WHERE id = \(Patient.id!)"
            defer {db.statment?.close()}
            
            let cursor = db.execute(text: text)
            
            defer {cursor.close()}
           
        } catch {
            print(error)
        }
        
    }

}
