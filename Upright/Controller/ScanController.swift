//
//  scanController.swift
//  Upright
//
//  Created by USS - Software Dev on 6/22/22.
//

import Foundation
import UIKit

class ScanController {
    
    struct ScanResults: Decodable {
        
        let id: String
        let p_c: Double
        let p_t: Double
        let p_l: Double
        let d_c: Double
        let d_t: Double
        let d_l: Double
        let lean: Double
    }
    
    private var scan:[ScanResults] = [] as! [ScanResults]
    private var scans:[PatientScan] = [] as! [PatientScan]
    var scanViewController: ScanControllsViewController
    // var bleManager: BLEManager = BLEManager()
    
    init(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        scanViewController = storyboard.instantiateViewController(withIdentifier: "ScanControllsViewController") as! ScanControllsViewController
    }
    
    private func linkScan(patient_id: Int, scan_id: Int){
        
        let database: db = db()
        defer {database.connection?.close()}
        let text = "UPDATE scans SET patient_id = \(patient_id) WHERE id = \(scan_id)"
        let result = database.execute(text: text)

        print(result)
    }
    
    func getScans() {
        
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            let text = "SELECT proportion_c, proportion_t, proportion_l, dl_c, dl_t, dl_l, to_char(date_stamp, 'yyyy-mm-dd'), lean, id, height FROM scans WHERE date_stamp = current_date AND organization_id = \(Organization.id!) ORDER BY id DESC LIMIT 5"
            defer {db.statment?.close()}
            
            let cursor = db.execute(text: text)
            
            defer {cursor.close()}
            
            for (row) in cursor {
                let columns = try row.get().columns
                let p_c = try columns[0].double()
                let p_t = try columns[1].double()
                let p_l = try columns[2].double()
                let dl_c = try columns[3].double()
                let dl_t = try columns[4].double()
                let dl_l = try columns[5].double()
                let id = try columns[8].int()
                let height = try columns[9].double()
                let time_stamp = try columns[6].string()
                let lean = try columns[7].double()
                //let pic_date = try columns[10].string()
                scans += createScanArray(id: id, p_c: p_c, p_t: p_t, p_l: p_l, dl_c: dl_c, dl_t: dl_t, dl_l: dl_l, time_stamp: time_stamp, lean: lean, height: height, pic_date: time_stamp)
            }
            
        } catch {
            print(error)
        }
    }
    
    private func createScanArray(id: Int, p_c: Double, p_t: Double, p_l: Double, dl_c: Double, dl_t: Double, dl_l: Double, time_stamp: String, lean: Double, height: Double, pic_date: String) -> [PatientScan]{
        var tempList: [PatientScan] = []
        let list = PatientScan(first_name: Patient.first_name!, last_name: Patient.last_name!, id: id, time_stamp: time_stamp, prop_C: p_c, prop_T: p_t, prop_L: p_l, dl_C: dl_c, dl_T: dl_t, dl_L: dl_l, lean: lean, height: height, pic_date: pic_date)
        tempList.append(list)

        return tempList
    }
    
//    func linkScan(){
//        if(scanId != nil){
//            var id = scanId.components(separatedBy: "-")
//            
//                let database: db = db()
//                let value = "INSERT INTO survey (patient_id,score,time_stamp) VALUES (\(Patient.id!),\(questionTotal),current_timestamp);"
//    
//    
//                    let result = database.execute(text: value)
//    
//                    print(result)
//        }
//    }
    
    func isConnected(){
       // bleManager.isConnected()
    }
    
    func reset() {
      //  bleManager.clearArray()
    }
    
    func getHeight(height: Double) -> String{
        let mm = Double(height)
        let toFeet = mm * 0.0032808
        let feet = toFeet.splitAtDecimal()
        let inch = feet.1 * 12
        return "\(String(feet.0))` \(String(inch.roundTo1f()))\""
    }
    
    func formatString(number: Double)-> String{
        return String((number * 100).roundTo0f())
    }
    
    func formatLean(lean: Double)-> String{
        return String(lean.roundTo0f())
    }
    
    func getScanResults() -> [ScanResults]{
        return self.scan
    }

}

extension Double {
    func roundTo0f() -> NSString {
        return NSString(format: "%.0f", self)
    }

    func roundTo1f() -> NSString {
          return NSString(format: "%.1f", self)
      }

    func roundTo2f() -> NSString {
          return NSString(format: "%.2f", self)
      }
    
    func splitAtDecimal() -> (Int, Double) {

            let whole = Int(self)
            let decimal = self - Darwin.floor(self)

            return (whole, decimal)
        }
  
}


