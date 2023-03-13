//
//  VSIReportCellModel.swift
//  Upright
//
//  Created by Sajjan on 15/02/2023.
//

import Foundation

struct VSIReportCellModel {
    
    let calculationValue: Calculations
    let patientScan: PatientScan
    let surveyData: QuestionsScore?
    
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
    
    
    
    static func getModel(patientId: Int, patientScan: PatientScan,
                         surveyData: QuestionsScore?, scanController: ScanController) -> VSIReportCellModel {
        
        let calcuation = Calculations(patient_id: patientId, prop_c: patientScan.prop_C, prop_t: patientScan.prop_T, prop_l: patientScan.prop_L, norm_c: patientScan.dl_C, norm_t: patientScan.dl_T, norm_l: patientScan.dl_L, lean: patientScan.lean)
        
        let vsiReportCellModel = VSIReportCellModel(calculationValue: calcuation,
                                                    patientScan: patientScan, surveyData: surveyData,
                                                    date: patientScan.time_stamp,
                                                    statureValue: scanController.getHeight(height: patientScan.height),
                                                    leanValue: scanController.formatLean(lean: abs(patientScan.lean)) + "º",
                                                    sXfXValue: String(surveyData?.score ?? 0),
                                                    proportionCervicalValue: scanController.formatString(number: patientScan.prop_C) + "%",
                                                    proportionThoracicValue: scanController.formatString(number: patientScan.prop_T) + "%",
                                                    proportionLumbarValue: scanController.formatString(number: patientScan.prop_L) + "%",
                                                    normalityCervicalValue: scanController.formatString(number: patientScan.dl_C) + "%",
                                                    normalityThoracicValue: scanController.formatString(number: patientScan.dl_T) + "%",
                                                    normalityLumbarValue: scanController.formatString(number: patientScan.dl_L) + "%",
                                                    vsiScoreValue: String(calcuation.getVsiScore()))
        return vsiReportCellModel
    }
    
    
}
