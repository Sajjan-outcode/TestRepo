//
//  NetworkRequestProtocol.swift
//  skyWatcher
//
//  Created by Nutan Niraula on 12/26/18.
//  Copyright © 2018 Nutan Niraula. All rights reserved.
//

import Foundation

protocol BaseModel: BaseRequestModel, BaseResponseModel {}

protocol BaseRequestModel: Encodable {}

struct EmptyBaseRequest: BaseRequestModel {}

extension BaseRequestModel {
    
    func getRequestParameters() -> [String: Any]? {
        let jsonEncoder = JSONEncoder()
        if let jsonData = try? jsonEncoder.encode(self) {
            do {
                return  try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            } catch {
                Utilities.printMessage(error.localizedDescription)
                return nil
            }
        }
        return nil
    }
    
    func toJsonString() -> String {
        do {
            guard let json = self.getRequestParameters() else { return "" }
            let jsonData = try? JSONSerialization.data(withJSONObject: json,
                                                       options: JSONSerialization.WritingOptions())
            if let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue) {
                return "\(jsonString)"
            }
            return ""
        }
    }
    
}
