//
//  db.swift
//  Upright
//
//  Created by USS - Software Dev on 3/2/22.
//

import Foundation
import PostgresClientKit



   

class db {
    let host: String = "52.90.36.209"
    let database: String = "myproject"
    let user: String = "myprojectuser"
    let ssl: Bool = false
    let credential: Credential = .scramSHA256(password: "crI4viaf")
    
    var configuration: ConnectionConfiguration = ConnectionConfiguration()
    var connection: Connection?
    var statment: Statement?
    var cursor : Cursor?
    
    var value : Cursor?
    var test : String?
   
    
     init(){
         connect()
    }
    
    func connect(){
        do{
        configuration = PostgresClientKit.ConnectionConfiguration()
        configuration.host = host
        configuration.database = database
        configuration.user = user
        configuration.ssl = ssl
        configuration.credential = credential
        connection = try PostgresClientKit.Connection(configuration: configuration)
    
        // defer {connection!.close()}
        } catch {
            print(error)
        }
    }
        
    func execute(text: String)-> Cursor {
        
            do {
                    
                statment = try connection!.prepareStatement(text: text)
              
                cursor = try statment!.execute()
                
            }catch{
                print(error)
            }
       

        return cursor!
        }
    
}
    
