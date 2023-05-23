//
//  RequestManager.swift
//  WiRFi
//
//  Created by Nutan Niraula on 1/3/19.
//  Copyright © 2019 Outcode. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireRequestManager: RequestCancellable {
    
    var request: URLSessionTask?
    
    init() {
        
    }
    
    init(withAlamofirerequest req: DataRequest) {
        self.request = req.task
    }
    
    init(withReq req: DownloadRequest) {
        self.request = req.task
    }
    
    func cancel() {
        guard let req = request else {
            Utilities.printMessage("******* NIL REQUEST ******")
            return
        }
        req.cancel()
        Utilities.printMessage("******* REQUEST CANCELLED ******")
    }
    
    func resume() {
        guard let req = request else {
            Utilities.printMessage("******* NIL REQUEST ******")
            return
        }
        req.resume()
        Utilities.printMessage("******* REQUEST RESUMED ******")
    }
    
    func pause() {
        guard let req = request else {
            Utilities.printMessage("******* NIL REQUEST ******")
            return
        }
        req.suspend()
        Utilities.printMessage("******* REQUEST PAUSED ******")
    }
}
