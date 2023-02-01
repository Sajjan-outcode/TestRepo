//
//  Scans.swift
//  Upright
//
//  Created by USS - Software Dev on 8/4/22.
//

import Foundation
import SwiftUI

class Scans {
    
  
    var unlinkedScans: [PatientScan] = []
    
    init(){
        listUnlinkedScans()
    }
    
    func listUnlinkedScans(){
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            let text = "SELECT s.id, p.first_name, p.last_name, s.proportion_c, s.proportion_t, s.proportion_l, s.dl_c, s.dl_t, s.dl_l, to_char(date_stamp, 'yyyy-mm-dd'), s.lean, s.height FROM patient p RIGHT JOIN scans s ON p.id = s.patient_id WHERE s.organization_id = \(Organization.id!) AND s.lean IS NOT NULL AND date_stamp >= CURRENT_DATE -30 ORDER BY s.id DESC"
            defer {db.statment?.close()}

            let cursor = db.execute(text: text)

            defer {cursor.close()}

            for (row) in cursor {
                let columns = try row.get().columns
                let id = try columns[0].int()
                let first_name = (try? columns[1].string()) ?? " "
                let last_name = (try? columns[2].string()) ?? " "
                let proportion_c = try columns[3].double()
                let proportion_t = try columns[4].double()
                let proportion_l = try columns[5].double()
                let dl_c = try columns[6].double()
                let dl_t = try columns[7].double()
                let dl_l = try columns[8].double()
                let time_stamp = try columns[9].string()
                let lean = try columns[10].double()
                let height = try columns[11].double()

                unlinkedScans.append(PatientScan(first_name: first_name, last_name: last_name, id: id, time_stamp: time_stamp, prop_C: proportion_c, prop_T: proportion_t, prop_L: proportion_l, dl_C: dl_c, dl_T: dl_t, dl_L: dl_l, lean: lean, height: height, pic_date: time_stamp))
            }
        } catch {
            print(error)
        }
    
    }
    
    func getUnlinkedScans()->[PatientScan]{
        return self.unlinkedScans
    }
}
