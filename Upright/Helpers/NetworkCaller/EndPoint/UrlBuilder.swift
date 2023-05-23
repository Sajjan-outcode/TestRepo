//
//  UrlBuilder.swift
//  skyWatcher
//
//  Created by Nutan Niraula on 12/21/18.
//  Copyright © 2018 Nutan Niraula. All rights reserved.
//
// swiftlint:disable all

import Foundation

class URLBuilder {
    
    private var components: URLComponents
    
    init() {
        self.components = URLComponents()
    }
    
    init(withBaseScheme scheme: String, baseHostUrl host: String) {
        self.components = URLComponents()
        self.components.scheme = scheme
        self.components.host = host
    }
    
    func set(scheme: String) -> URLBuilder {
        self.components.scheme = scheme
        return self
    }
    
    func set(host: String) -> URLBuilder {
        self.components.host = host
        return self
    }
    
    func set(port: Int?) -> URLBuilder {
        if let port = port {
            self.components.port = port
        }
        return self
    }
    
    func set(path: String) -> URLBuilder {
        var path = path
        if !path.hasPrefix("/") {
            path = "/\(path)"
        }
        if !path.hasSuffix("/") {
            path = "\(path)/"
        }
        self.components.path = path
        return self
    }
    
    func removeQueryItems() -> URLBuilder {
        self.components.queryItems = nil
        return self
    }
    
    func addQueryItem(name: String, value: String) -> URLBuilder  {
        if self.components.queryItems == nil {
            self.components.queryItems = []
        }
        self.components.queryItems?.append(URLQueryItem(name: name, value: value))
        return self
    }
    
    func build() -> URL? {
        return self.components.url
    }
}
// swiftlint:enable all
