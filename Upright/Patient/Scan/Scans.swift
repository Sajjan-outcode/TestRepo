//
//  Scans.swift
//  Upright
//
//  Created by USS - Software Dev on 8/4/22.
//

import Foundation

class Scans {
    
    let unlinkedScansQuery = "SELECT * FROM scans WHERE organization_id =\(Organization.id!) AND patient_id = NULL"
    var unlinkedScans: [PatientScan] = []
    
    func listUnlinkedScans(){
        do {
            let db:db = db.init()
            defer {db.connection?.close()}
            let text = "SELECT id, patient_id, proportion_c, proportion_t, proportion_l, dl_c, dl_t, dl_l, CAST(time_stamp AS VARCHAR), lean FROM scans WHERE organization_id =\(Organization.id!) AND patient_id = NULL"
            defer {db.statment?.close()}

            let cursor = db.execute(text: text)

            defer {cursor.close()}

            for (row) in cursor {
                let columns = try row.get().columns
                let id = try columns[0].int()
                let patient_id = try columns[1].int()
                let proportion_c = try columns[2].double()
                let proportion_t = try columns[3].double()
                let proportion_l = try columns[4].double()
                let dl_c = try columns[5].double()
                let dl_t = try columns[6].double()
                let dl_l = try columns[7].double()
                let time_stamp = try columns[8].string()
                let lean = try columns[9].double()

                unlinkedScans.append(PatientScan(id: patient_id, time_stamp: time_stamp, prop_C: proportion_c, prop_T: proportion_t, prop_L: proportion_l, dl_C: dl_c, dl_T: dl_t, dl_L: dl_l, lean: lean))
            }
        } catch {
            print(error)
        }
    
    }
}
