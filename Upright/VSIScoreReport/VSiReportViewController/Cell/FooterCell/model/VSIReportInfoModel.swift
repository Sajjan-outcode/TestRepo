//
//  VSIReportInfoModel.swift
//  Upright
//
//  Created by Sajjan on 15/02/2023.
//

import Foundation

struct VSIReportInfoModel {
    let patientFirstName: String
    let patientEmail: String
    var currentDate: String
    let clinicName: String
    let clinicAddress: String
    let clinicPhone: String
    let clinicEmail: String
    
    init(patientFirstName: String, patientEmail: String, clinicName: String,
         clinicAddress: String, clinicPhone: String, clinicEmail: String) {
        self.patientFirstName = patientFirstName
        self.patientEmail = patientEmail
        self.clinicName = clinicName
        self.clinicAddress = clinicAddress
        self.clinicPhone = clinicPhone
        self.clinicEmail = clinicEmail
        self.currentDate = ""
    }
    
    func setCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "MM/dd/yyyy"
          
        return  dateFormatter.string(from: date)
       
    }
    
    static func getNewVSIReportInfoModel() -> VSIReportInfoModel {
       return VSIReportInfoModel(patientFirstName: "\(Patient.first_name ?? " ")" + " " + "\(Patient.last_name ?? " ")",
                                  patientEmail: Patient.email ?? "",
                                  clinicName: Organization.name ?? "",
                                  clinicAddress: Organization.address ?? "",
                                  clinicPhone: "", clinicEmail: Organization.email ?? "")
    }
}
