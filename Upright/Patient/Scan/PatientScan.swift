//
//  PatientScan.swift
//  Upright
//
//  Created by USS - Software Dev on 4/30/22.
//

import Foundation
import UIKit

class PatientScan {
    
     var id: Int?
     var time_stamp: String?
     var prop_C: Double?
     var prop_T: Double?
     var prop_L: Double?
     var dl_C: Double?
     var dl_T: Double?
     var dl_L: Double?
     var lean: Double?
    
    init(id: Int, time_stamp: String, prop_C: Double, prop_T: Double, prop_L: Double, dl_C: Double, dl_T: Double, dl_L: Double, lean: Double) {
        self.id = id
        self.time_stamp = time_stamp
        self.prop_C = prop_C
        self.prop_T = prop_T
        self.prop_L = prop_L
        self.dl_C = dl_C
        self.dl_T = dl_T
        self.dl_L = dl_L
        self.lean = lean
    }
}
