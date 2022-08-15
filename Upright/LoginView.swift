//
//  Loginview.swift
//  Upright
//
//  Created by USS - Software Dev on 6/6/22.
//

import Foundation
import UIKit


class LoginView: LoginViewController {
    
    private var password:String!
    
    func getUserInfo(userName: String){
        let db: db = db.init()
        defer {db.connection?.close()}
        let text = "SELECT organization.id, name, address, city, state, zip, password, email FROM organization WHERE email = '\(userName)'"
        let cursor = db.execute(text: text)
        defer {db.statment?.close()}
        defer {cursor.close()}
        do {
            for row in cursor {
                let columns = try row.get().columns
                Organization.id = try columns[0].int()
                Organization.name = try columns[1].string()
                Organization.address = try columns[2].string()
                Organization.city = try columns[3].string()
                Organization.state = try columns[4].string()
                Organization.zip = try columns[5].string()
                Organization.email = try columns[7].string()
                self.password = try columns[6].string()
            }
            } catch {
             print(error)
            }
    }
    
    func validateUser(password:String)->Bool{
        
        var valid : Bool
        if(self.password == password){
            valid = true
        }else {
            valid = false
        }
        return valid
    }
    
}


