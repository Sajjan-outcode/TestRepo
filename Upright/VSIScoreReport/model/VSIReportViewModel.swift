//
//  VSIReportViewModel.swift
//  Upright
//
//  Created by Sajjan on 08/02/2023.
//

import UIKit

class VSIReportViewModel {
    
    var reportGeneratDate: String
    var patientEmail: String
    var patientName: String
    var dateValue: String
    var statureValue: String
    var leanValue: String
    var sXfXValue: String
    var proportionCervicalValue: String
    var proportionThoracicValue: String
    var proportionLumbarValue: String
    var normalityCervicalValue: String
    var normalityThoracicValue: String
    var normalityLumbarValue: String
    var vsiScoreValue: String
    var clinicModel: ClinicModel?
    //var patientScanList: [PatientScan]
    //   var calculation: Calculations?
    
    
    init(patientScan: PatientScan, scanController: ScanController, generateDate:String,calculation: Calculations) {
        self.reportGeneratDate = generateDate
        self.patientName = patientScan.first_name
        self.patientEmail = Patient.email ?? ""
        self.dateValue = patientScan.time_stamp
        self.statureValue = scanController.getHeight(height: patientScan.height)
        self.leanValue = scanController.formatLean(lean: patientScan.lean) + "º"
        self.sXfXValue = "n/a"
        self.proportionCervicalValue = scanController.formatString(number: patientScan.prop_C) + "%"
        self.proportionThoracicValue = scanController.formatString(number: patientScan.prop_T) + "%"
        self.proportionLumbarValue = scanController.formatString(number: patientScan.prop_L) + "%"
        self.normalityCervicalValue = scanController.formatString(number: patientScan.dl_C) + "%"
        self.normalityThoracicValue = scanController.formatString(number: patientScan.dl_T) + "%"
        self.normalityLumbarValue = scanController.formatString(number: patientScan.dl_L) + "%"
        self.vsiScoreValue = String(calculation.getVsiScore())
        
    }
    
    func getDeltaValue(patient:PatientScan){
        
      
        
    }
    
    
}


