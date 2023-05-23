//
//  Token.swift
//  skyWatcher
//
//  Created by Nutan Niraula on 12/26/18.
//  Copyright © 2018 Nutan Niraula. All rights reserved.
//

import Foundation

class TokenManager: NSObject {
    
    static let shared = TokenManager()
    var accessToken: String? {
        get {
            return UserDefaults.standard.value(forKey: NetworkKeys.UserDefaults.accessToken) as? String
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: NetworkKeys.UserDefaults.accessToken)
            UserDefaults.standard.synchronize()
        }
    }

    var refreshToken: String?
    
    func initializeToken() { // call this in app delegate
        if let accessToken =  UserDefaults.standard.string(forKey: NetworkKeys.UserDefaults.accessToken) {
            //  let refreshToken =  UserDefaults.standard.string(forKey: NetworkKeys.UserDefaults.refreshToken) {
            TokenManager.shared.accessToken = accessToken
//            SharedInstance.shared.refreshToken = refreshToken
        }
    }
    
}
