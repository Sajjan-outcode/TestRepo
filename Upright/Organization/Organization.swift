//
//  Organization.swift
//  Upright
//
//  Created by USS - Software Dev on 6/6/22.
//

import Foundation

struct Organization {
    static var id : Int?
    static var name : String?
    static var address : String?
    static var city: String?
    static var state: String?
    static var zip: String?
    static var email: String?
    static var isAdmin: Bool?
    
    static var isOrganizationAdmin: Bool {
        return (Organization.isAdmin.isTrue)
    }
}

extension Optional where Wrapped == Bool {
    
    var isTrue: Bool {
        return (self ?? false)
    }
}

extension Bool {
    
    var isFalse: Bool {
        return !self
    }
}
