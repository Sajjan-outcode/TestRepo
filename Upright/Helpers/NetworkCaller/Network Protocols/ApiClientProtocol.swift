//
//  ApiClientProtocol.swift
//  skyWatcher
//
//  Created by Nutan Niraula on 12/26/18.
//  Copyright © 2018 Nutan Niraula. All rights reserved.
//

import UIKit
import Alamofire

protocol APIClient {
    
    var endPoint: EndPointProtocol { get set }
    var cancellableRequest: RequestCancellable { get set }
    var code: Int? { get set }
    func request(withObject object: BaseRequestModel?, completion: @escaping ((NetworkResult<Data?>) -> Void))
    func request(withParams params: [String: Any]?, completion: @escaping ((NetworkResult<Data?>) -> Void))
    func upload(data: Data,
                key: String,
                type: String?,
                progressValue: @escaping (_ progress: Progress?) -> Void,
                completion: @escaping ((NetworkResult<Data?>) -> Void))
    func sendMultipartData(imgObject: [String: ([Data], String)],
                           requestObj: BaseRequestModel?,
                           progressValue: @escaping (_ progress: Double) -> Void,
                           completion: @escaping ((NetworkResult<Data?>) -> Void))
    func sendMultipartData(toUrl url: String,
                           file: (Data, (String, String)),
                           requestParam: [String: Any]?,
                           progressValue: @escaping (_ progress: Double) -> Void,
                           completion: @escaping ((NetworkResult<Data?>) -> Void))
    func download(toUrl url: String,
                  destinationURL: @escaping DownloadRequest.DownloadFileDestination,
                  progressValue: @escaping (_ progress: Double) -> Void,
                  completion: @escaping ((NetworkResult<Data?>) -> Void))
}

extension APIClient {

    func animateNetworkIndicator(start: Bool = true) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = start
    }
    
}
