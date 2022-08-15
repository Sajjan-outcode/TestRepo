//
//  Settings.swift
//  Upright
//
//  Created by USS - Software Dev on 7/14/22.
//

import Foundation
import UIKit

class Settings{
    
    private var probType: Int8
    private var deviceHeight: Int32
    private var probPressure: Int8
    private var deviceSpeed: Int8
    
    init(probType: Int8, deviceHeight: Int32, probPressure: Int8, deviceSpeed:Int8){
        self.probType = probType
        self.deviceHeight = deviceHeight
        self.probPressure = probPressure
        self.deviceSpeed = deviceSpeed
    }
    
    func getProbType() -> Int8{
        return self.probType
    }
    
    func getDeviceHeight() -> Int32 {
        return self.deviceHeight
    }
    
    func getProbPressure() -> Int8 {
        return self.probPressure
    }
    
    func getDeviceSpeed() -> Int8 {
        return self.deviceSpeed
    }
    
}
