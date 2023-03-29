//
//  VSIReportModel.swift
//  Upright
//
//  Created by Sajjan on 07/02/2023.
//

import Foundation

struct VSIReporDeltaCellModel {
    
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
   
    
    static func getModel(patientId: Int, patientScanCell: [VSIReportCellModel]) -> VSIReporDeltaCellModel! {
        if patientScanCell.isEmpty { return nil }
        if patientScanCell.count == 1 {
            return VSIReporDeltaCellModel(date: "DELTA",
                                          statureValue: " N/A ",
                                          leanValue: "N/A",
                                          sXfXValue: "N/A",
                                          proportionCervicalValue: "N/A",
                                          proportionThoracicValue: "N/A",
                                          proportionLumbarValue: "N/A",
                                          normalityCervicalValue: "N/A",
                                          normalityThoracicValue: "N/A",
                                          normalityLumbarValue: "N/A",
                                          vsiScoreValue:"N/A")
        } else {
            let  scanController: ScanController = ScanController()
            guard let first = patientScanCell.first,
                  let last = patientScanCell.last else { return nil }
            let firstCalcuation = Calculations(patient_id: patientId, prop_c: first.patientScan.prop_C, prop_t: first.patientScan.prop_T, prop_l: first.patientScan.prop_L, norm_c: first.patientScan.dl_C, norm_t: first.patientScan.dl_T, norm_l: first.patientScan.dl_L, lean: first.patientScan.lean)
            let firstVSISocre = firstCalcuation.getVsiScore()
            
            let lastCalcuation = Calculations(patient_id: patientId, prop_c: last.patientScan.prop_C, prop_t: last.patientScan.prop_T, prop_l: last.patientScan.prop_L, norm_c: last.patientScan.dl_C, norm_t: last.patientScan.dl_T, norm_l: last.patientScan.dl_L, lean: last.patientScan.lean)
            let lastVSISocre = lastCalcuation.getVsiScore()
            let calcHeight = scanController.getHeight(height: last.patientScan.height - first.patientScan.height)
            
          
            return VSIReporDeltaCellModel(date: "DELTA",
                                          statureValue: "\(calcHeight) ",
                                          leanValue: "\(Int(last.patientScan.lean - first.patientScan.lean))º",
                                          sXfXValue: "",
                                          proportionCervicalValue:
                                            "\(scanController.formatString(number: last.patientScan.prop_C - first.patientScan.prop_C)) %",
                                          proportionThoracicValue:
                                            "\(scanController.formatString(number: last.patientScan.prop_T - first.patientScan.prop_T)) %",
                                          proportionLumbarValue:
                                            "\(scanController.formatString(number: last.patientScan.prop_L - first.patientScan.prop_L)) %",
                                          normalityCervicalValue:
                                            "\(scanController.formatString(number: last.patientScan.dl_C - first.patientScan.dl_C)) %",
                                          normalityThoracicValue:
                                            "\(scanController.formatString(number: last.patientScan.dl_T - first.patientScan.dl_T)) %",
                                          normalityLumbarValue:
                                            "\(scanController.formatString(number: last.patientScan.dl_L - first.patientScan.dl_L)) %",
                                          vsiScoreValue:
                                            "\(lastVSISocre - firstVSISocre)")
             }
           
        }
    
}
