//
//  NetworkResult.swift
//  Nimbus
//
//  Created by Nutan Niraula on 12/25/18.
//  Copyright © 2018 Nutan Niraula. All rights reserved.
//
// swiftlint:disable all

import UIKit

enum NetworkResult<Value> {
    case success(Value)
    case failure(Error)
}

extension NetworkResult where Value == Data? {
    
    func data() -> Data? {
        switch self {
        case .success(let data):
            return data
        case .failure(_):
            return nil
        }
    }
    
    func decodeJson<ResponseType: Decodable>(toType: ResponseType.Type) -> NetworkResult<ResponseType>  {
        switch self {
        case .success(let data):
            do {
                guard let data = data else {
                    return NetworkResult<ResponseType>.failure(NetworkError.apiError(apiMessage: "data is nil", code: ""))
                }
                let decoder = JSONDecoder()
                let decodedResult = try decoder.decode(ResponseType.self, from: data)
                //                print("decoded \(decodedResult)")
                return NetworkResult<ResponseType>.success(decodedResult)
            } catch let error {
                Utilities.printMessage("error \(error.localizedDescription)")
                return NetworkResult<ResponseType>.failure(error)
            }
        case .failure(let error):
            return NetworkResult<ResponseType>.failure(error)
        }
    }
    
    func decodeResponse() -> (Error?, [String: Any]?)  {
        switch self {
        case .success(let data):
            do {
                guard let data = data else {
                    return (NetworkError.apiError(apiMessage: "data is nil", code: ""), nil)
                }
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                return (nil, json)
            } catch let error {
                //                print("error \(error.localizedDescription)")
                return (error, nil)
            }
        case .failure(let error):
            return (error, nil)
        }
    }
    
    func getUIImage() -> NetworkResult<UIImage>  {
        switch self {
        case .success(let data):
            guard let imgData = data, let image = UIImage(data: imgData) else {
                return NetworkResult<UIImage>.failure(NetworkError.apiError(apiMessage: "image couldn't be decoded", code: ""))
            }
            return NetworkResult<UIImage>.success(image)
        case .failure(let error):
            return NetworkResult<UIImage>.failure(error)
        }
    }
    
}
// swiftlint:disable all
