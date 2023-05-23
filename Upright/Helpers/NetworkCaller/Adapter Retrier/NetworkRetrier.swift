// swiftlint:disable all
////
////  NetworkRetrier.swift
////  skyWatcher
////
////  Created by Nutan Niraula on 12/26/18.
////  Copyright © 2018 Nutan Niraula. All rights reserved.
////
//import Foundation
//import Alamofire
//
//TODO: uncomment after implementing Oauth flow in app
//enum RetryResult {
//    var retryResult: Bool {
//        switch self {
//        case .failure,.networkError :
//            return false
//        default:
//            return true
//        }
//    }
//    case success
//    case failure
//    case networkError
//}
//
//class RefreshTokenModel:BaseRequestModel {
//    var refreshToken:String?
//    private enum CodingKeys: String, CodingKey {
//        case refreshToken = "refresh_token"
//    }
//}
//
//class NetworkRetrier:RequestRetrier {
//    private typealias RefreshCompletion = (_ succeeded: RetryResult) -> Void
//    private let lock = NSLock()
//    private var isRefreshing = false
//    private var requestsToRetry: [RequestRetryCompletion] = []
//
//    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
//        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 , request.retryCount < 1 && request.request?.url?.absoluteString != "Login url" {
//            if let token = SharedInstance.shared.accessToken, request.request?.allHTTPHeaderFields![NetworkKeys.Headers.Authorization] != "Bearer \(token)" {
//                completion(true,1.0)
//            }else {
//                requestsToRetry.append(completion)
//                if !isRefreshing {
//                    print("Token expired trying to refresh")
//                    refreshTokens { [weak self] succeeded in
//                        guard let strongSelf = self else { return }
//                        strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
//                        switch succeeded {
//                        case .failure:
//                            completion(false, 0.0)
//                            self?.showAlertAndLogoutUser()
//                        case .success: print("Refresh Successs")
//                        case .networkError: print("Network Error while retrying")
//                        }
//                        strongSelf.requestsToRetry.forEach { $0(succeeded.retryResult, 0.0) }
//                        strongSelf.requestsToRetry.removeAll()
//                        strongSelf.isRefreshing = false
//                    }
//                }
//            }
//        } else {
//            completion(false, 0.0) //dont retry request
//        }
//    }
//
//    private func refreshTokens(completion: @escaping RefreshCompletion) {
//        guard !isRefreshing else { return }
//        isRefreshing = true
//        let refreshToken = RefreshTokenModel()
//        guard let  token =  SharedInstance.shared.refreshToken else {
//            print("token not found to refresh")
//            return
//        }
//        refreshToken.refreshToken = token
//        let alamofireManager = Alamofire.SessionManager(configuration: NetworkConfigurator.sharedManager.sessionConfiguration)
//        alamofireManager.request(AppUrls.RefreshToken, method: .post, parameters: refreshToken.getRequestParameters(), encoding: URLEncoding.default,headers:nil)
//            .responseData { response in
//                let jsonString = String(data: response.data!, encoding: String.Encoding.utf8) ?? "Data could not be printed"
//                print(jsonString)
//                switch(response.result) {
//                case .success(let  data):
//                    if let obj = try? JSONDecoder().decode(BaseResponse<EmptyBaseResponse>.self,from:data), obj.status?.code == "ok" {
//                        response.saveAccessToken()
//                        completion(.success)
//                    }else{
//                        print("Session expired. Cannot refresh token")
//                        completion(.failure)
//                    }
//                case .failure(_):
//                    print("Session expired. Cannot refresh token in failure block")
//                    completion(.networkError)
//                }
//        }
//    }
//
//    func showAlertAndLogoutUser() {
//        //clear app credentials
//        //show alerts
//        //route out of app with (session expired) message
//    }
//}
//
//extension DataResponse {
//    func saveAccessToken() {
//        if self.request?.url?.absoluteString == "Login url" || self.request?.url?.absoluteString == AppUrls.RefreshToken {
//            if let accessToken = self.response?.allHeaderFields["Access-Token"] as? String, let refreshToken = self.response?.allHeaderFields["Refresh-Token"] as? String {
//                SharedInstance.shared.accessToken = accessToken
//                SharedInstance.shared.refreshToken = refreshToken
//                UserDefaults.standard.set(accessToken, forKey: NetworkKeys.UserDefaults.accessToken)
//                UserDefaults.standard.set(refreshToken, forKey: NetworkKeys.UserDefaults.refreshToken)
//                UserDefaults.standard.synchronize()
//            }
//        }
//    }
//}
// swiftlint:enable all
