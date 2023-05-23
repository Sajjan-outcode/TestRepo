//
//  VSIReportDeviationCellModel.swift
//  Upright
//
//  Created by Sajjan on 10/03/2023.
//

import Foundation

class TargetValue  {
    
    let leanValue = 0
    let sXfXValue = 100
    let proportionCervicalValue = 25
    let proportionThoracicValue = 45
    let proportionLumbarValue = 30
    let normalityCervicalValue = 12
    let normalityThoracicValue = 12
    let normalityLumbarValue = 12
    let vsiScoreValue = 0
}

struct VSIReportDeviationCellModel {
    
    let date: String
    let statureValue: String
    let leanValue: String
    let sXfXValue: String
    let proportionCervicalValue: String
    let proportionThoracicValue: String
    let proportionLumbarValue: String
    let normalityCervicalValue: String
    let normalityThoracicValue: String
    let normalityLumbarValue: String
    let vsiScoreValue: String
   
    static func getModel(patientId: Int,patientScanCell: [VSIReportCellModel], questionSurvey : [QuestionsScore]) -> VSIReportDeviationCellModel! {
        if patientScanCell.isEmpty { return nil }
            guard let firstValue = patientScanCell.first else { return nil }
            let lastCalcuation = Calculations(patient_id: patientId, prop_c: firstValue.patientScan.prop_C, prop_t: firstValue.patientScan.prop_T, prop_l: firstValue.patientScan.prop_L, norm_c: firstValue.patientScan.dl_C, norm_t: firstValue.patientScan.dl_T, norm_l: firstValue.patientScan.dl_L, lean: firstValue.patientScan.lean)
        let  scanController: ScanController = ScanController()
        let targetValue = TargetValue()
        guard let deviationSurveyScore = questionSurvey.first?.score else { return nil }
        
        guard let calLeanValue = Int(scanController.formatLean(lean: abs(firstValue.patientScan.lean))),
        let calProportionCervicalValue  =  Int(scanController.formatString(number: firstValue.patientScan.prop_C)),
        let calProportionThoracicValue  =  Int(scanController.formatString(number: firstValue.patientScan.prop_T)),
        let calProportionLumbarValue    =  Int(scanController.formatString(number: firstValue.patientScan.prop_L)),
        let calNormalityCervicalValue   =  Int(scanController.formatString(number: firstValue.patientScan.dl_C)),
        let calNormalityThoracicValue   =  Int(scanController.formatString(number: firstValue.patientScan.dl_T)),
        let calNormalityLumbarValue     =  Int(scanController.formatString(number: firstValue.patientScan.dl_L))
       
        else { return nil }
     
            return VSIReportDeviationCellModel(date: "DEVIATION",
                                               statureValue: "n/a ",
                                               leanValue: "\(abs(targetValue.leanValue - calLeanValue))º",
                                               sXfXValue: "\(targetValue.sXfXValue - deviationSurveyScore)",
                                          proportionCervicalValue:
                                                "\(targetValue.proportionCervicalValue - calProportionCervicalValue) %",
                                          proportionThoracicValue:
                                                "\(targetValue.proportionThoracicValue - calProportionThoracicValue) %",
                                          proportionLumbarValue:
                                                "\(targetValue.proportionLumbarValue - calProportionLumbarValue) %",
                                          normalityCervicalValue:
                                                "\(targetValue.normalityCervicalValue - calNormalityCervicalValue) %",
                                          normalityThoracicValue:
                                                "\(targetValue.normalityThoracicValue - calNormalityThoracicValue) %",
                                          normalityLumbarValue:
                                                "\(targetValue.normalityLumbarValue - calNormalityLumbarValue) %",
                                          vsiScoreValue:
                                                "\(abs(targetValue.vsiScoreValue - lastCalcuation.getVsiScore()))")
             }
           
        }
