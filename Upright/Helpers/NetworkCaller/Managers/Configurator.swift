//
//  Configurator.swift
//  skyWatcher
//
//  Created by Nutan Niraula on 12/26/18.
//  Copyright © 2018 Nutan Niraula. All rights reserved.
//

import Foundation

public class NetworkConfigurator {
    static let sharedManager = NetworkConfigurator()
    let requestTimeOutInterval: Double = 60 //seconds
    let responseTimeOutInterval: Double =  86400
    var sessionConfiguration: URLSessionConfiguration
    var cachePolicy: NSURLRequest.CachePolicy = .returnCacheDataElseLoad
    
    init() {
        sessionConfiguration = URLSessionConfiguration.default //ephemeral and background
        sessionConfiguration.timeoutIntervalForRequest = requestTimeOutInterval //secs
        sessionConfiguration.timeoutIntervalForResource = responseTimeOutInterval//secs
//        sessionConfiguration.
        URLCache.shared = {
            URLCache(memoryCapacity: 100 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: nil)
        }()
    }
}
