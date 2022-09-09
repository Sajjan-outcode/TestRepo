//
//  CreateProvider.swift
//  Upright
//
//  Created by USS - Software Dev on 6/3/22.
//

import Foundation

class CreateProvider: CreateProviderView {
    
    
    func submitProvider(organization_id: Int, first_name: String, last_name: String, address: String, city: String, state: String, zip: Int, password: String, username: String, email: String) {
        let database: db = db()
        let value = "INSERT INTO provider (organization_id, first_name, last_name, address, city, state, zip, password, username, email) VALUES ('\(organization_id)',\(first_name),'\(last_name)','\(address)','\(city)','\(state)','\(zip)','\(password)',\(username)"
        
        
            let result = database.execute(text: value)
            
          //  print(result)
        
    }
}
