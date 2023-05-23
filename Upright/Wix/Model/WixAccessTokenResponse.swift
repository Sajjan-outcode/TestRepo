//
//  WixAccessTokenResponse.swift
//  Upright
//
//  Created by outcode  on 16/05/2023.
//

import Foundation


struct WixAccessTokenResponse: Decodable {
    
    var accessToken: String
    var refreshToken: String
    
    public enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
    
    func getAuthorizationHeader() -> String {
        return "\(accessToken)"
    }
    
}
