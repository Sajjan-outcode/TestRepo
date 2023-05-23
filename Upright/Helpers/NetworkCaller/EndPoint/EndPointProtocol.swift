//
//  EnDpointModel.swift
//  skyWatcher
//
//  Created by Nutan Niraula on 12/21/18.
//  Copyright © 2018 Nutan Niraula. All rights reserved.
//

import Foundation
import Alamofire

protocol EndPointProtocol {
    var url: URL? {get set}
    var method: HTTPMethods {get}
}
