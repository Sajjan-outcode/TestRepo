//
//  NetworkCaller.swift
//  skyWatcher
//
//  Created by Nutan Niraula on 12/26/18.
//  Copyright © 2018 Nutan Niraula. All rights reserved.
//
// swiftlint:disable all

import Foundation
import Alamofire

class NetworkCaller: APIClient {
    
    var cancellableRequest: RequestCancellable
    var endPoint: EndPointProtocol
    var alamofireSessionManger: Alamofire.SessionManager!
    var code: Int?
    static let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    var sessionExpired = false
    
    var appdelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    init(endPoint: EndPointProtocol) {
        self.endPoint = endPoint
        self.alamofireSessionManger = Alamofire.SessionManager(configuration: NetworkConfigurator.sharedManager.sessionConfiguration)
//        alamofireSessionManger.adapter = NetworkAdapter()
        self.cancellableRequest = AlamofireRequestManager()
        //TODO: uncomment after implementing Oauth flow in app
        //        alamofireSessionManger.retrier = NetworkRetrier()
    }
    
    func request(withObject object: BaseRequestModel? = nil, completion: @escaping ((NetworkResult<Data?>) -> Void)) {
        self.animateNetworkIndicator(start: true)
        guard let url = self.endPoint.url else {return}
        
        let request = alamofireSessionManger.request(url, method: self.endPoint.method.alamofireEquivalentHTTPMethod(), parameters: object?.getRequestParameters(), encoding: self.endPoint.method.encodingType, headers: nil).validate(statusCode: 200...499)
        
        self.cancellableRequest = AlamofireRequestManager(withAlamofirerequest: request)
        if let req = request.request {
            Utilities.printMessage("*** API REQUEST *** \n REQUEST URL: \(String(describing: req))\n REQUEST HEADERS: \(String(describing: request.request?.allHTTPHeaderFields))\n REQUEST BODY: \(String(describing: request.request?.httpBody?.prettyPrintedJson()))")
        }
        
        request.responseData { [weak self] (dataResponse) in
            switch dataResponse.result {
            case .success(let data):

                self?.hideNoInternetConnectionLabel()
                Utilities.printMessage("\(data.prettyPrintedJson())")
                let code = dataResponse.response!.statusCode
                self?.code = code
                // this is pattern matching code which is same as if code >= 400 && code <= 499
                if 400 ... 499 ~= code {
                    //condition for session expiry
                    if code == 403 || code == 401 {
                        completion(NetworkResult.failure(NetworkError.sessionExpired))
                        return
                    }
                    completion(NetworkResult.failure((self?.parseErrorMessage(fromData: data))!))
                } else if 200 ... 299 ~= code {
                    completion(NetworkResult.success(data))
                }
            case .failure(let error):
                if (error as NSError).code ==  -1020 {
                    completion(NetworkResult.failure(NetworkError.notConnectedToInternet))
                    return
                }
                completion(NetworkResult.failure(error))
            }
        }
        self.animateNetworkIndicator(start: false)
    }
    
    func request(withParams params: [String:Any]?,
                 completion: @escaping ((NetworkResult<Data?>) -> Void)) {
        self.animateNetworkIndicator(start: true)
        guard let url = self.endPoint.url else {return}
        let header = [
            "\(NetworkKeys.Headers.apiKey)" : "10d7e45a4e1ec226b12d3d1ffa8d946638e688c3",
            "\(NetworkKeys.Headers.ContentType)" : "application/x-www-form-urlencoded"
        ]
        
        Alamofire.request(url,
                          method: self.endPoint.method.alamofireEquivalentHTTPMethod(),
                          parameters: params,
                          headers: header).responseData{ [weak self] (dataResponse) in
            switch dataResponse.result {
            case .success(let data):
                
                self?.hideNoInternetConnectionLabel()
                Utilities.printMessage("\(data.prettyPrintedJson())")
                let code = dataResponse.response!.statusCode
                self?.code = code
                // this is pattern matching code which is same as if code >= 400 && code <= 499
                if 400 ... 499 ~= code {
                    //condition for session expiry
                    if code == 403 || code == 401 {
                        completion(NetworkResult.failure(NetworkError.sessionExpired))
                        return
                    }
                    completion(NetworkResult.failure((self?.parseErrorMessage(fromData: data))!))
                } else if 200 ... 299 ~= code {
                    completion(NetworkResult.success(data))
                }
            case .failure(let error):
                
                completion(NetworkResult.failure(error))
            }
        }
        self.animateNetworkIndicator(start: false)
    }
    
    func hideNoInternetConnectionLabel() {
        // implement yourself
    }
    
    func expireSession() {
        // implement expire session
    }
    
    func parseErrorMessage(fromData data: Data) -> Error {
        do {
            // swiftlint:disable force_cast
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            // swiftlint:enable force_cast
            if let firstKeyValue = json.first(where: { (item) -> Bool in
                if let _ = item.value as? [String] {
                    return true
                }
                return false
            }) { // expecting the error response to be an object with a key having string array as value
                let code = json["code"] as? String ?? ""
                if let message = (firstKeyValue.value as? [String])?.first {
                    let err = NetworkError.apiError(apiMessage: message,
                                                    code: "\(code)")
                    return err
                }
            } else if let errorMessage = json.first?.value as? String { // expecting the error response to be an object with a key having string as value
                let code = json["code"] as? String ?? ""
                let err = NetworkError.apiError(apiMessage: errorMessage,
                                                code: "\(code)")
                return err
            }
        } catch let error {
            return error
        }
        return NetworkError.apiError(apiMessage: "Unknown Error", code: "")
    }
    
    func upload(data: Data,
                key: String,
                type: String? = nil,
                progressValue: @escaping (_ progress: Progress?) -> Void = { _ in },
                completion: @escaping ((NetworkResult<Data?>) -> Void)) {
        guard let url = self.endPoint.url else {return}
        let multipartFormData = MultipartFormData()
        multipartFormData.append(data, withName: key, fileName: "\(key).png", mimeType: data.mimeType)
        if let temp = type {
            multipartFormData.append(temp.data(using: .utf8)!, withName: "type")
        } else {
            Utilities.printMessage("Type not set for this image")
        }
        guard let data = try? multipartFormData.encode() else {
            fatalError("Could not decode data")
        }
        animateNetworkIndicator(start: true)
        let request = alamofireSessionManger.upload(data,
                                                    to: url,
                                                    method: .post,
                                                    headers: ["Content-Type": multipartFormData.contentType])
        self.cancellableRequest = AlamofireRequestManager(withAlamofirerequest: request)
        request.uploadProgress(closure: { (progress) in
            progressValue(progress)
        })
        request.responseData(completionHandler: {(response) in
            switch response.result {
            case .success(let data):
                completion(NetworkResult.success(data))
            case .failure(let error):
                completion(NetworkResult.failure(error))
            }
            self.animateNetworkIndicator(start: false)
        })
        
    }
    
    // This function is used to convert [String:Any] to jsonString
    private func convertDictionaryToJsonString(dict: [String: Any]) -> String {
        let jsonData = try? JSONSerialization.data(withJSONObject: dict,
                                                   options: JSONSerialization.WritingOptions())
        if let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue) {
            return "\(jsonString)"
        }
        return ""
    }
    
    func sendMultipartData(imgObject: [String: ([Data], String)],
                           requestObj: BaseRequestModel? = nil,
                           progressValue: @escaping (_ progress: Double) -> Void = { _ in },
                           completion: @escaping ((NetworkResult<Data?>) -> Void)) {
        guard let url = self.endPoint.url else {return}
        let multipartFormData = MultipartFormData()
        
        if let reqObj = requestObj, let param = reqObj.getRequestParameters() {
            for (key, value) in param {
                if let nestedJson = value as? [String: Any] {
                    let str = convertDictionaryToJsonString(dict: nestedJson)
                    multipartFormData.append(str.data(using: .utf8)!, withName: key)
                    Utilities.printMessage("converted \(String(describing: str)) \(key))")
                } else {
                    // if it is not nested json convert all other type to string and encode it to utf8
                    multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
                    Utilities.printMessage("converted \(String(describing: value)) \(key))")
                }
            }
        }
        
        for (key, value) in imgObject {
            for (_, data) in value.0.enumerated() {
                multipartFormData.append(data, withName: key, fileName: value.1, mimeType: data.mimeType)
            }
        }
            
        guard let data = try? multipartFormData.encode() else {
            fatalError("Couldnot decode data")
        }
        animateNetworkIndicator(start: true)
        
        let string = data.base64EncodedString()

        let newData = Data(base64Encoded: string)
        
        let request = alamofireSessionManger.upload(newData!,
                                                    to: url,
                                                    method: endPoint.method.alamofireEquivalentHTTPMethod(),
                                                    headers: ["Content-Type": multipartFormData.contentType])
            .validate(statusCode: 200...499)
        self.cancellableRequest = AlamofireRequestManager(withAlamofirerequest: request)
        
        Utilities.printMessage("*** API REQUEST *** \n REQUEST URL: \(String(describing: request.request))\n REQUEST HEADERS: \(String(describing: request.request?.allHTTPHeaderFields))\n REQUEST BODY: \(String(describing: request.request?.httpBody?.prettyPrintedJson()))")
        request.uploadProgress(closure: { (progress) in
            Utilities.printMessage("PROGRESS \(progress)")
            DispatchQueue.main.async {
               progressValue(progress.fractionCompleted)
            }
        })
        request.responseData(completionHandler: {[weak self] (response) in
            switch response.result {
            case .success(let data):
                
                self?.hideNoInternetConnectionLabel()
                Utilities.printMessage("DATA: \(data.prettyPrintedJson())")
                let code = response.response!.statusCode
                self?.code = code
                // this is pattern matching code which is same as if code >= 400 && code <= 499
                if 400 ... 499 ~= code {
                    //condition for session expiry
                    if code == 401 {
                        self?.expireSession()
                        return
                    }
                    completion(NetworkResult.failure((self?.parseErrorMessage(fromData: data))!))
                } else if 200 ... 299 ~= code {
                    completion(NetworkResult.success(data))
                }
            case .failure(let error):
                completion(NetworkResult.failure(error))
            }
            self?.animateNetworkIndicator(start: false)
        })
        
        
    }
    
    //s3 server call
    func sendMultipartData(toUrl url: String,
                           file: (Data, (String, String)),
                           requestParam: [String:Any]?,
                           progressValue: @escaping (_ progress: Double) -> Void,
                           completion: @escaping ((NetworkResult<Data?>) -> Void)) {
        
        let multipartFormData = MultipartFormData()
        
        if let param = requestParam {
            for (key, value) in param {
                multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
            }
        }
        multipartFormData.append(file.0, withName: file.1.0, fileName: file.1.1, mimeType: file.0.mimeType)
           
        guard let data = try? multipartFormData.encode() else {
            fatalError("Couldnot decode data")
        }
        animateNetworkIndicator(start: true)
        
        let string = data.base64EncodedString()

        let newData = Data(base64Encoded: string)
        let header = [
            NetworkKeys.Headers.ContentType: multipartFormData.contentType,
            NetworkKeys.Headers.removeAuthorization : "1"
        ]
        
        let request = alamofireSessionManger.upload(newData!,
                                                    to: url,
                                                    method: endPoint.method.alamofireEquivalentHTTPMethod(),
                                                    headers: header)
            .validate(statusCode: 200...499)
        self.cancellableRequest = AlamofireRequestManager(withAlamofirerequest: request)
        
        request.responseData(completionHandler: {[weak self] (response) in
            switch response.result {
            case .success(let data):
                
                self?.hideNoInternetConnectionLabel()
                Utilities.printMessage("DATA: \(data.prettyPrintedJson())")
                let code = response.response!.statusCode
                self?.code = code
                // this is pattern matching code which is same as if code >= 400 && code <= 499
                if 400 ... 499 ~= code {
                    //condition for session expiry
                    if code == 401 {
                        self?.expireSession()
                        return
                    }
                    completion(NetworkResult.failure((self?.parseErrorMessage(fromData: data))!))
                } else if 200 ... 299 ~= code {
                    completion(NetworkResult.success(data))
                }
            case .failure(let error):
                completion(NetworkResult.failure(error))
            }
            self?.animateNetworkIndicator(start: false)
        })
        
        request.uploadProgress(closure: { (progress) in
            Utilities.printMessage("PROGRESS \(progress)")
            DispatchQueue.main.async {
               progressValue(progress.fractionCompleted)
            }
        })
    }
    
    func download(toUrl url: String,
                  destinationURL: @escaping DownloadRequest.DownloadFileDestination,
                  progressValue: @escaping (Double) -> Void,
                  completion: @escaping ((NetworkResult<Data?>) -> Void)) {
        animateNetworkIndicator(start: true)
        guard let url = URL(string: url) else { return }
        let header = [
            NetworkKeys.Headers.ContentType: "1",
            NetworkKeys.Headers.removeAuthorization : "1"
        ]
        let request = alamofireSessionManger.download(url,
                                                      method: .get,
                                                      encoding: URLEncoding.default,
                                                      headers: header,
                                                      to: destinationURL)
        
        self.cancellableRequest = AlamofireRequestManager(withReq: request)
        request.responseData(completionHandler: {(response) in
            switch response.result {
            case .success(let data):
                completion(NetworkResult.success(data))
            case .failure(let error):
                completion(NetworkResult.failure(error))
            }
            self.animateNetworkIndicator(start: false)
        })
        request.downloadProgress { (progress) in
            Utilities.printMessage(progress.fractionCompleted)
            progressValue(progress.fractionCompleted)
        }
    }
}
// swiftlint:enable all
