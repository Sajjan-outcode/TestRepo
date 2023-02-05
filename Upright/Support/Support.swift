//
//  Support.swift
//  Upright
//
//  Created by USS - Software Dev on 7/12/22.
//

import Foundation

struct SupportVideosWrapper: Codable {
    var videos: [SupportVideo]
    
    func save() {
        do {
            let data = try JSONEncoder().encode(self)
            UserDefaults.standard.set(data,
                                     forKey: "support_videos")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func getVideos() -> [SupportVideo] {
        guard let videosJsonString = UserDefaults.standard.value(forKey: "support_videos") as? String else {
            return []
        }
        return Utilities.decodeString(videosJsonString, toType: SupportVideosWrapper.self)?.videos ?? []
    }
}

struct SupportVideo: Codable {
    let id: String
    let title: String
    let description: String
    let link: String
    
}
