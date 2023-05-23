//
//  EndPointBuilder.swift
//  skyWatcher
//
//  Created by Nutan Niraula on 12/27/18.
//  Copyright © 2018 Nutan Niraula. All rights reserved.
//

import Foundation
import Alamofire

class EndPointBuilder {
    private struct BaseEndPoint: EndPointProtocol {
        var url: URL?
        var method: HTTPMethods = .get
    }
    
    static func getEndPoint(fromUrl url: URL?, Httpmethod method: HTTPMethods) -> EndPointProtocol {
        var endPoint = BaseEndPoint()
        endPoint.url = url
        endPoint.method = method
        return endPoint
    }
}
