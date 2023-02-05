//
//  DatabaseManager.swift
//  Upright
//
//  Created by Ashwin Shrestha on 03/02/2023.
//

import Foundation

class DatabaseManager: NSObject {
    
    private let database: db
    static let shared: DatabaseManager = {
        let instance = DatabaseManager(database: db())
        return instance
    }()
    
    init(database: db) {
        self.database = database
    }
    
    func closeDataBaseConnection() {
        database.connection?.close();
    }
    
    func getSupportVideos(completion: @escaping(([SupportVideo]) -> Void)){
        var supportVideos: [SupportVideo] = []
        let text = "SELECT * FROM support_video"
        let cursor = database.execute(text: text)
        defer {cursor.close()}
        
        for (row) in cursor {
            do {
                let columns = try row.get().columns
                let id = try columns[0].string()
                let title = try columns[1].string()
                let description = try columns[2].string()
                let link = try columns[3].string()
                supportVideos.append(SupportVideo(id: id, title: title, description: description, link: link))
            } catch {
                print(error)
            }
        }
        completion(supportVideos)
    }
    
    func deleteSupportVideos(video: SupportVideo, completion: @escaping((Bool, SQLError?) -> Void)){
        let text = "DELETE FROM support_video where video_id = '\(video.id)'"
        database.executeQuery(text: text) { (cursor, error) in
            if let error = error {
                completion(false, error)
                return
            } else if let cursor = cursor {
                cursor.close()
                completion(true, nil)
                return
            }
            completion(false, SQLError.apiError(apiMessage: "Somethign went wrong", code: ""))
        }
    }
    
    func addNewSupportVideo(video: SupportVideo, completion: @escaping((Bool, SQLError?) -> Void)) {
        let text = "INSERT INTO support_video (video_id, title, description, link) VALUES('\(video.id)', '\(video.title)', '\(video.description)', '\(video.link)');"
        database.executeQuery(text: text) { (cursor, error) in
            if let error = error {
                completion(false, error)
                return
            } else if let cursor = cursor {
                cursor.close()
                completion(true, nil)
                return
            }
            completion(false, SQLError.apiError(apiMessage: "Somethign went wrong", code: ""))
        }
    }
}
