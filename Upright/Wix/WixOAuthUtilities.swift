//
//  OAuthService.swift
//  Upright
//
//  Created by outcode  on 16/05/2023.
//
import Foundation

class WixOAuthUtilities {
    
    static func decodeJson<ResponseType: Decodable>(from data: Data,
                                                    toType:ResponseType.Type) -> ResponseType? {
        
        do {
            
            return try JSONDecoder().decode(ResponseType.self, from: data)
            
        } catch {
            return nil
        }
        
    }
    
    static func getUrl( with clientId:String, and redirectUrl:String) -> (URL)? {
        
        
        let wixAuthURLFull = WixConstants.authUrl + "?appId=" + clientId + "&redirectUrl=" + redirectUrl
        
        guard let url = URL(string: wixAuthURLFull) else {return nil}
        return(url)
        
    }
    
    static func hasCallBackPrefix(_ string:String , redirectUrl: String) -> Bool {
        return string.hasPrefix(redirectUrl)
    }
    
    static func getAccessTokenAndState(from url:URL) -> (String)? {
        guard let urlComponents = URLComponents(url: url , resolvingAgainstBaseURL: true),
              let queryParams = urlComponents.queryItems,
              let tokenParam = queryParams.first(where: {(item) -> Bool in
                  return item.name == "code"
              }),
              let token = tokenParam.value else {return nil}
        
        return (token)
        
    }
    
}

