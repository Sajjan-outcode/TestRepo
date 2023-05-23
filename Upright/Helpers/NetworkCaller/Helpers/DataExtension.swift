//
//  DataExtension.swift
//  skyWatcher
//
//  Created by Nutan Niraula on 12/28/18.
//  Copyright © 2018 Nutan Niraula. All rights reserved.
//
// swiftlint:disable all
import Foundation

extension Data {
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/vnd",
        0x46 : "text/plain",
        ]
    
    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "video/mp4"
    }
    
    func prettyPrintedJson() -> String {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers), let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            return String(decoding: jsonData, as: UTF8.self)
        } else {
            return "invalid json data"
        }
//        let jsonString = String(data: self, encoding: String.Encoding.utf8) ?? "Data could not be printed"
//        return jsonString
    }
    
}
// swiftlint:enable all
