//
//  db.swift
//  Upright
//
//  Created by USS - Software Dev on 3/2/22.
//

import Foundation
import PostgresClientKit

enum SQLError: Error {
    case apiError(apiMessage: String, code: String)
}

class db {
    
    
    static var host: String!
    static var dev: Bool!
    let database: String =  "myproject" // "unity"//  "myproject"  -> old db name reference
    let user: String =  "myprojectuser" //"myprojectuser" -> -> old  username reference
    let ssl: Bool = false
    // var credential: Credential =
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
        configuration.host = db.host!
        configuration.database = database
        configuration.user = user
        configuration.ssl = ssl
        configuration.credential = !db.dev! ? .scramSHA256(password: "crI4viaf") : .scramSHA256(password:"t3stus3r" )//"t3stus3r" "crI4viaf")
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
        } catch{
            print(error)
        }
       return cursor!
    }
    
    func executeQuery(text: String, completion: @escaping ((Cursor?, SQLError?) -> Void)) {
        guard let connection = connection else {
            completion(nil, SQLError.apiError(apiMessage: "connection not available", code: ""))
            return
        }
        do {
            statment = try connection.prepareStatement(text: text)
            guard let cursor = try statment?.execute() else {
                completion(nil, SQLError.apiError(apiMessage: "Error executing command", code: ""))
                return
            }
            completion(cursor, nil)
        } catch {
            completion(nil, SQLError.apiError(apiMessage: error.localizedDescription, code: ""))
        }
    }
    
}
    
