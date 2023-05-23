//
//  NetworkAdapter.swift
//  skyWatcher
//
//  Created by Nutan Niraula on 12/26/18.
//  Copyright © 2018 Nutan Niraula. All rights reserved.
//

import Foundation
import Alamofire

//class NetworkAdapter: RequestAdapter {
////    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
////        var urlRequestConfig = urlRequest
////        if !UserSessionManager.isUserLoggedIn {
////            // handle headers when user is not logged in
////
////        }
////
////        urlRequestConfig.setValue(Utilities.getId(), forHTTPHeaderField: NetworkKeys.Headers.DeviceId)
////
////        urlRequestConfig.setValue("ios", forHTTPHeaderField: NetworkKeys.Headers.Platform)
////        urlRequestConfig.setValue(Utilities.appVersion, forHTTPHeaderField: NetworkKeys.Headers.AppVersion)
////
////        let headerFields = urlRequestConfig.allHTTPHeaderFields ?? [:]
////
////        if  headerFields.index(forKey: NetworkKeys.Headers.ContentType).isNil {
////            urlRequestConfig.setValue("application/json",
////            forHTTPHeaderField: NetworkKeys.Headers.ContentType)
////        } else if headerFields[NetworkKeys.Headers.ContentType] == "1" {
////           urlRequestConfig.setValue(nil, forHTTPHeaderField: NetworkKeys.Headers.ContentType)
////        }
////
////        if  headerFields.index(forKey: NetworkKeys.Headers.removeAuthorization).isNil {
////            guard let authToken = TokenManager.shared.accessToken else {
////                return urlRequestConfig
////            }
////            urlRequestConfig.setValue(String(format: "Token %@", authToken),
////                                      forHTTPHeaderField: NetworkKeys.Headers.Authorization)
////        }
////        return urlRequestConfig
////    }
//}
