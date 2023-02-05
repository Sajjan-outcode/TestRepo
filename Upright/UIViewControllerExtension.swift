//
//  UIViewControllerExtension.swift
//  Upright
//
//  Created by Ashwin Shrestha on 03/02/2023.
//

import UIKit

extension UIViewController {
    
    func showErrorAlert(error: SQLError?) {
        guard let error = error else {
            return
        }
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

struct Utilities {
    
    static func decodeJson<ResponseType: Decodable>(_ json: [String: Any],
                                                    toType: ResponseType.Type) -> ResponseType? {
        do {
            guard let data = Utilities.makeData(from: json) else {
                return nil
            }
            let decoder = JSONDecoder()
            let decodedResult = try decoder.decode(ResponseType.self, from: data)
            //                print("decoded \(decodedResult)")
            return decodedResult
        } catch {
            print(error)
            return nil
        }
    }
    
    static func makeData(from json: [String: Any]) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch {
            return nil
        }
    }
    
    static func decodeString<ResponseType: Decodable>(_ string: String,
                                                      toType: ResponseType.Type) -> ResponseType? {
        do {
            guard let data = string.data(using: .utf8) else {
                return nil
            }
            let decoder = JSONDecoder()
            let decodedResult = try decoder.decode(ResponseType.self, from: data)
            //                print("decoded \(decodedResult)")
            return decodedResult
        } catch {
            return nil
        }
    }
}
