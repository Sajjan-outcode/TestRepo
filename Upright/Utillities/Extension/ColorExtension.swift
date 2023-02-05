//
//  ColorExtension.swift
//  Upright
//
//  Created by Sajjan on 05/02/2023.
//

import Foundation
import UIKit

extension UIColor {
    
    public convenience init(hex6String: String, alpha: CGFloat = 1) {

        let strippedString = hex6String.replacingOccurrences(of: "#", with: "")
        
        let hex6 = Int.init(strippedString, radix: 16) ?? 0x000000
    
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    
    }

    static func colorWith(string: String) -> UIColor {
        return UIColor.init(hex6String: string)
    }

}
