//
//  WixOAuthNetworkCaller.swift
//  Upright
//
//  Created by outcode  on 16/05/2023.
//

import Foundation

struct WixOAuthNetworkCaller {
    
    static func getTokenUrlReguest(with code: String,
                                   clientId: String,
                                   secretKey: String,
                                   redirectUrl: String,
                                   completionHandler: @escaping((WixAccessTokenResponse?, Error?) -> Void)){
        
        let session = URLSession.shared
        let url = URL(string: WixConstants.accessTokenRequestUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        
        
        let json = [
            "grant_type": "authorization_code",
            "client_id": clientId,
            "client_secret": secretKey,
            "code": code,
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            
            let task = session
                .uploadTask(with: request,
                            from: jsonData) { (data, _, error) in
                                if let data = data,
                                    let response = WixOAuthUtilities.decodeJson(from: data,
                                                                                   toType: WixAccessTokenResponse.self) {
                                    completionHandler(response, nil)
                                    return
                                }
                                completionHandler(nil, error)
            }
            task.resume()
        } catch {
            fatalError("Hey developer check your code")
        }
        
        
    }
   
    
    
    
}
