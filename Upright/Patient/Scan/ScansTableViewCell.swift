//
//  ScansTableViewCell.swift
//  Upright
//
//  Created by USS - Software Dev on 4/30/22.
//

import UIKit

class ScansTableViewCell: UITableViewCell {

   
    @IBOutlet weak var Scans: UILabel!
    
    func setScans(scans: PatientScan) {
        Scans.text = scans.time_stamp
        print("this is a time stamp" + scans.time_stamp!)
    }

}
