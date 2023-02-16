//
//  VSIReportModel.swift
//  Upright
//
//  Created by Sajjan on 07/02/2023.
//

import Foundation

struct VSIReportModel {
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
   
    
    init(reportGeneratDate: String, patientEmail: String, patientName: String, dateValue: String, statureValue: String, leanValue: String, sXfXValue: String, proportionCervicalValue: String, proportionThoracicValue: String, proportionLumbarValue: String, normalityCervicalValue: String, normalityThoracicValue: String, normalityLumbarValue: String, vsiScoreValue: String) {
        self.reportGeneratDate = reportGeneratDate
        self.patientEmail = patientEmail
        self.patientName = patientName
        self.dateValue = dateValue
        self.statureValue = statureValue
        self.leanValue = leanValue
        self.sXfXValue = sXfXValue
        self.proportionCervicalValue = proportionCervicalValue
        self.proportionThoracicValue = proportionThoracicValue
        self.proportionLumbarValue = proportionLumbarValue
        self.normalityCervicalValue = normalityCervicalValue
        self.normalityThoracicValue = normalityThoracicValue
        self.normalityLumbarValue = normalityLumbarValue
        self.vsiScoreValue = vsiScoreValue
  
    }
    
    
    
}
